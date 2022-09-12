class ResponseWrapper<T> {
  T data;
  String responseCode;
  String responseMessage;

  ResponseWrapper({required this.data, required this.responseCode, required this.responseMessage});

  ResponseWrapper.fromJson(Map json) :
        data = json['data'],
        responseCode = json['responseCode'],
        responseMessage = json['responseMessage'];
}