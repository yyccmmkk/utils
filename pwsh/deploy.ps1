$account = gc D:/.account;
#user:password
curl -u $account  -X GET  http://192.168.12.71:9779/job/build?token=b78b6c1f9815d88
