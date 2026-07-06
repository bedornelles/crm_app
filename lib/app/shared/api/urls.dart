bool get _isProduction => false;

String get crmApiUrl => _isProduction ? 'http://10.0.1.107:5018' : 'http://10.0.1.107:5018';