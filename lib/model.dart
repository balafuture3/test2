class Model {
  SoapEnvelope soapEnvelope;

  Model({this.soapEnvelope});

  Model.fromJson(Map<String, dynamic> json) {
    soapEnvelope = json['soap:Envelope'] != null
        ? new SoapEnvelope.fromJson(json['soap:Envelope'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.soapEnvelope != null) {
      data['soap:Envelope'] = this.soapEnvelope.toJson();
    }
    return data;
  }
}

class SoapEnvelope {
  SoapBody soapBody;

  SoapEnvelope({this.soapBody});

  SoapEnvelope.fromJson(Map<String, dynamic> json) {
    soapBody = json['soap:Body'] != null
        ? new SoapBody.fromJson(json['soap:Body'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.soapBody != null) {
      data['soap:Body'] = this.soapBody.toJson();
    }
    return data;
  }
}

class SoapBody {
  IndusMobileAllEmpListResponse indusMobileAllEmpListResponse;

  SoapBody({this.indusMobileAllEmpListResponse});

  SoapBody.fromJson(Map<String, dynamic> json) {
    indusMobileAllEmpListResponse =
    json['IndusMobileAllEmpListResponse'] != null
        ? new IndusMobileAllEmpListResponse.fromJson(
        json['IndusMobileAllEmpListResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.indusMobileAllEmpListResponse != null) {
      data['IndusMobileAllEmpListResponse'] =
          this.indusMobileAllEmpListResponse.toJson();
    }
    return data;
  }
}

class IndusMobileAllEmpListResponse {
  String indusMobileAllEmpListResult;

  IndusMobileAllEmpListResponse({this.indusMobileAllEmpListResult});

  IndusMobileAllEmpListResponse.fromJson(Map<String, dynamic> json) {
    indusMobileAllEmpListResult = json['IndusMobileAllEmpListResult'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IndusMobileAllEmpListResult'] = this.indusMobileAllEmpListResult;
    return data;
  }
}