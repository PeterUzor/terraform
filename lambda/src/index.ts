import {
  DataServiceImplementation,
  DataService
} from './services/data.service';

exports.handler = async (event: any) => {
  try {
    console.log(event.body);
    const dataService: DataService = new DataServiceImplementation();
    const data = JSON.parse(event.body);
    let response = await dataService.saveJson(data);
    return response;
  } catch (error) {
    console.log(error);
    throw error;
  }
};
