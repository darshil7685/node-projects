exports.throwError = (status, message) => {
    const error = new Error();error
    error.status = status;
    error.message = message;
    return error;
}