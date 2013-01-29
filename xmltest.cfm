<cfscript>
	oAdmin = createObject("component", "cfide.adminapi.base");

	str1 = '<?xml version="1.0" encoding="utf-8" standalone="no"?> 
					<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
						<XMLTrans> 
							<transType>04</transType> 
							<accountNum>3130000</accountNum> 
							<invNum>cc1</invNum> 
							<status>58</status> 
							<ResponseCode>51</ResponseCode> 
							<transNum>1820</transNum> 
							<authCode>110722003913</authCode> 
							<AVS>Y</AVS> 
							<CVV2Resp>M</CVV2Resp> 
							<Response>Success</Response> 
						</XMLTrans>
					</XMLResponse>';

	str2 = '<?xml version="1.0" encoding="utf-8" standalone="no"?> 
					<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
						<XMLTrans> 
							<transType>36</transType> 
							<accountNum>1547785</accountNum> 
							<invNum>ach1</invNum> 
							<status>00</status> 
							<transNum>1820</transNum> 
						</XMLTrans>
					</XMLResponse>';

	str3 = '<?xml version="1.0" encoding="utf-8" standalone="no"?> 
					<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
						<XMLTrans> 
							<transType>05</transType> 
							<accountNum>3130000</accountNum> 
							<invNum>G67613E</invNum> 
							<status>58</status> 
							<ResponseCode>51</ResponseCode> 
							<transNum>74</transNum> 
							<authCode>712312022933</authCode> 
							<AVS>N</AVS> 
							<CVV2Resp>N</CVV2Resp> 
							<Response>hold card</Response> 
						</XMLTrans>
					</XMLResponse>';

	str4 = '<?xml version="1.0" encoding="utf-8" standalone="no"?> 
					<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
						<XMLTrans> 
							<transType>06</transType>
							<transNum>477263</transNum> 
							<status>57</status> 
						</XMLTrans>
					</XMLResponse>';

	str5 = '<?xml version="1.0" encoding="utf-8" standalone="no"?> 
					<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
						<XMLTrans> 
							<transType>07</transType> 
							<accountNum>3130000</accountNum> 
							<transNum>453123</transNum> 
							<status>00</status> 
						</XMLTrans>
					</XMLResponse>';

	str6 = '<?xml version="1.0" standalone="no"?> 
					<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd>
						<XMLTransactions> 
							<XMLTrans> 
								<transType>34</transType> 
								<accountNum>123456</accountNum> 
								<invNum>cc1</invNum> 
								<status>00</status> 
								<ResponseCode>00</ResponseCode> 
								<transNum>1820</transNum> 
								<authCode>110722</authCode> 
								<AVS>Y</AVS> 
								<CVV2Resp>M</CVV2Resp> 
								<Response>Success</Response> 
								<amount>100</amount> 
								<ccNumLastFour>9999</ccNumLastFour> 
								<netAmount>97</netAmount> 
								<txnStatus>CCDebitSettled<txnStatus> 
								<txnType></txnType>
								<payerName>Jane Doe</payerName> 
								<Comment1>This is a sales order</Comment2> 
								<Comment2></Comment2> 
								<result></result> 
								<InvoiceExternalRefNum></InvoiceExternalRefNum> 
								<initialTransactionResult></initialTransactionResult> 
							</XMLTrans> 
						</XMLTransactions>
					</XMLResponse>';

	results = xmlParse(str1);
	try 
	{
		oAdmin.dump(XmlSearch(results,"//:XMLTrans"));

		// if ( isarray(transactionResult) && arraylen(transactionResult) == 1 ) 
		// {

		// 	if ( structkeyexists(transactionResult[1], "Result") && structkeyexists(variables.ProPayResponseCodes,transactionResult[1].Result.xmlText) ) 
		// 	{
		// 		local.processorData.setMessage(variables.ProPayResponseCodes[transactionResult[1].Result.xmlText]);
		// 	}
		// 	else if ( structkeyexists(transactionResult[1], "Message") ) 
		// 	{
		// 		local.processorData.setMessage(transactionResult[1].Message.xmlText);
		// 	}
		// 	else
		// 	{
		// 		local.processorData.setMessage("No message found.");
		// 	}
			
		// 	if ( structkeyexists(transactionResult[1], "PNRef") ) 
		// 	{
		// 		local.processorData.setTransactionID(transactionResult[1].PNRef.xmlText);
		// 	}
			
		// 	if ( structkeyexists(transactionResult[1], "AuthCode") ) 
		// 	{
		// 		local.processorData.setAuthorization(transactionResult[1].AuthCode.xmlText);
		// 	}
			
		// 	if ( structkeyexists(transactionResult[1],"AVSResult") ) 
		// 	{
		// 		local.processorData.setAVSCode(transactionResult[1].AVSResult.xmlText);
		// 	}
			
		// 	if ( structkeyexists(transactionResult[1], "Result") ) 
		// 	{
		// 		switch (transactionResult[1].Result.xmlText) 
		// 		{
		// 			case "0": 
		// 			{
		// 				local.processorData.setStatus(getService().getStatusSuccessful());
		// 				break;
		// 			}
		// 			case "12": 
		// 			{
		// 				local.processorData.setStatus(getService().getStatusDeclined());
		// 				break;
		// 			}
		// 			case "23": 
		// 			{
		// 				local.processorData.setStatus(getService().getStatusDeclined());
		// 				break;
		// 			}
		// 			case "126": 
		// 			{
		// 				local.processorData.setStatus(getService().getStatusSuccessful());
		// 				break;
		// 			}
		// 			default: 
		// 			{
		// 				local.processorData.setStatus(getService().getStatusFailure());
		// 				break;
		// 			}
		// 		}
		// 	}
		// }
		// else
		// {
		// 	local.processorData.setStatus(getService().getStatusUnknown());
		// 	local.processorData.setMessage("Required Xml node missing from transaction response or there were too many of the necessary Xml node(s). [#arraylen(transactionResult)#]");
		// }
	}
	catch(Any e) 
	{
		oAdmin.dump(e);
	}
</cfscript>