class UserDescriptor {
  String _name;
  String _email;
  String _imageURL;
  UserDescriptor();
  UserDescriptor.init(this._name, this._email);

  setImageUrl(String url) {
    this._imageURL = url;
  }

  Map<String, String> getUserDetails() {
    return {
      "Name": this._name,
      "Email": this._email,
      "Image": this._imageURL,
    };
  }

  updateDetails(String name, String email) {
    this._name = name;
    this._email = email;
  }

  fromMap(Map<String, dynamic> data, String email) {
    this._email = email;
    this._imageURL = data['Profile Image'];
    this._name = data['Name'];
  }

  String getEmail() => this._email;
  String getName() => this._name;
  String getImageUrl() => this._imageURL;
}
