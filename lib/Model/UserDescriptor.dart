class UserDescriptor {
  String _name;
  String _email;
  String _imageURL;

  UserDescriptor();
  UserDescriptor.init(this._name, this._email);

  setImageUrl(String url) {
    this._imageURL = url;
  }

  String getImageUrl() => this._imageURL;

  Map<String, String> getUserDetails() {
    return {
      "Name": this._name,
      "Email": this._email,
      "Image": this._imageURL,
    };
  }

  updateDetails(name) {
    this._name = name;
  }

  fromMap(Map<String, dynamic> data, String email) {
    this._email = email;
    this._imageURL = data['Profile Image'];
    this._name = data['Name'];
  }

  getEmail() => this._email;
}
