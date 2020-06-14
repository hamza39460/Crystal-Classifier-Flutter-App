class WorkspaceDescriptor{
  String _firebaseID;
  String _name;
  String _description;
  String _dateCreated;

  WorkspaceDescriptor();
  
  WorkspaceDescriptor.init(this._name,this._description,this._dateCreated);

  WorkspaceDescriptor.previous(this._firebaseID,this._name,this._description,this._dateCreated); 
  
  String getName()=>_name;

  String getDescription()=>_description;

  String getCreationDate()=>_dateCreated;

  String setFirebaseID(String id){
    this._firebaseID=id;
  }

  Map<String,String>getAllDetails(){
    return {
      'Name': this._name,
      'Description':this._description,
      'Created on':this._dateCreated
    };
  }
}