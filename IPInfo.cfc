component name="IPInfo"{
	variables.api_url 	= "https://ipinfo.io/";
	variables.token 	= "";

	public IPInfo function init(
		required string token
	){
		variables.token = arguments.token;

		return this;
	}

	public struct function geolocation_data(
		required string ip_address
	){
		local.return_data = {
			request_uri: variables.api_url & arguments.ip_address & "/json?token=" & variables.token,
			success: false,
			errors: [],
			raw_response: {},
			response: {}
		};

		try {
			local.http_call = new HTTP(url=local.return_data.request_uri, method="get");
			local.http_call.addParam(type="header", name="Content-Type", value="application/json");

			local.return_data.raw_response = local.http_call.send().getPrefix();
			local.return_data.response = deserializeJSON(local.return_data.raw_response.fileContent);

			if(local.return_data.raw_response.keyExists("statusCode") && local.return_data.raw_response.statusCode.find("200")){
				local.return_data.success = true;
			}
		}
		catch(any err){
			local.return_data.errors.append(err.message & " - " & err.detail);
		}

		return local.return_data;
	}
}