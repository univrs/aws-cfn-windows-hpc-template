var AWS = require('aws-sdk');
var ec2 = new AWS.EC2({region: process.env.AWS_REGION});

/// This part taken from http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-lambda-function-code.html
SUCCESS = "SUCCESS";
FAILED = "FAILED";

function send_response(event, context, responseStatus, responseData, physicalResourceId) {
    var responseBody = JSON.stringify({
        Status: responseStatus,
        Reason: "See the details in CloudWatch Log Stream: " + context.logStreamName,
        PhysicalResourceId: physicalResourceId || context.logStreamName,
        StackId: event.StackId,
        RequestId: event.RequestId,
        LogicalResourceId: event.LogicalResourceId,
        Data: responseData
    });

    console.log("Response body:\n", responseBody);

    var https = require("https");
    var url = require("url");

    var parsedUrl = url.parse(event.ResponseURL);
    var options = {
        hostname: parsedUrl.hostname,
        port: 443,
        path: parsedUrl.path,
        method: "PUT",
        headers: {
            "content-type": "",
            "content-length": responseBody.length
        }
    };

    var request = https.request(options, function(response) {
        console.log("Status code: " + response.statusCode);
        console.log("Status message: " + response.statusMessage);
        context.done();
    });

    request.on("error", function(error) {
        console.log("send(..) failed executing https.request(..): " + error);
        context.done();
    });

    request.write(responseBody);
    request.end();
}
/// End copy

exports.handler = function(event, context) {
  var properties = event.ResourceProperties;
  var params = {
    Filters: [
      { Name: 'tag:Name', Values: [ properties.SnapshotName ] }
    ],
    RestorableByUserIds: [ 'self' ]
  };
  if((event.RequestType == 'Create') || (event.RequestType == 'Update')) {
    ec2.describeSnapshots(params, function(err, data) {
      if (err) {
        send_response(event, context, FAILED, { SnapshotId: '', Reason: 'An error occured while calling EC2:' + err });
      } else {
        var snapshots = data.hasOwnProperty('Snapshots') ? data.Snapshots : [];
        if (snapshots.length > 0) {
          snapshots.sort(function (a, b) { return ((a.Name > b.Name) ? -1 : ((a.Name > b.Name) ? 0 : 1)) });
          send_response(event, context, SUCCESS, { SnapshotId: snapshots[0].SnapshotId, Reason: 'Snapshot found' });
        } else {
          send_response(event, context, FAILED, { SnapshotId: '', Reason: 'No such snapshot found' });
        }
      }
    });
  } else {
    send_response(event, context, SUCCESS, { SnapshotId: '', Reason: 'Resource deleted' });
  }
};
