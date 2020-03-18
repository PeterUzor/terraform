import * as uuid from 'uuid';
import * as AWS from 'aws-sdk';

export interface DataService {
  saveJson(jsonObject: any): Promise<any>;
}

export class DataServiceImplementation implements DataService {
  private s3Bucket: AWS.S3;

  constructor() {
    this.s3Bucket = new AWS.S3({
      accessKeyId: process.env.AWS_ACCESS_KEY,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
    });
  }

  public async saveJson(jsonObject: any): Promise<any> {
    return await this.uploadObject(jsonObject);
  }

  private async uploadObject(data: any): Promise<any> {
      const params = {
        Bucket: 'zazu-s3-bucket',
        Key: `${uuid}.json`,
        Body: JSON.stringify(data),
        ContentType: 'application/json',
      };
      return this.s3Bucket.putObject(params, (s3Err: any, data: any) => {
        if (s3Err) throw s3Err;
        console.log(`File uploaded successfully at ${data.Location}`);
      });
  };
}
