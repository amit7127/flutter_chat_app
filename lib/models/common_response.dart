enum Status { LOADING, COMPLETED, ERROR }

class CommonsResponse<T> {
  Status status;
  T data;
  String message;
  int responseCode;

  CommonsResponse.loading(this.message) : status = Status.LOADING;

  CommonsResponse.completed(this.data, {this.message}) : status = Status.COMPLETED;

  CommonsResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return 'Status : $status \n Code : $responseCode \n Message : $message \n Data : $data';
  }
}
