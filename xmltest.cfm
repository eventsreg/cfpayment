<cfset variables.ProPayResponseCodes = {} />
<cfset variables.ProPayStatusCodes = {} />

<cfset variables.ProPayStatusCodes["00"] = "Success" />
<cfset variables.ProPayStatusCodes["20"] = "Invalid username" />
<cfset variables.ProPayStatusCodes["21"] = "Invalid transType or service not allowed" />
<cfset variables.ProPayStatusCodes["22"] = "Invalid Currency Code" />
<cfset variables.ProPayStatusCodes["23"] = "Invalid accountType" />
<cfset variables.ProPayStatusCodes["24"] = "Invalid sourceEmail" />
<cfset variables.ProPayStatusCodes["25"] = "Invalid firstName" />
<cfset variables.ProPayStatusCodes["26"] = "Invalid mInitial" />
<cfset variables.ProPayStatusCodes["27"] = "Invalid lastName" />
<cfset variables.ProPayStatusCodes["28"] = "Invalid billAddr" />
<cfset variables.ProPayStatusCodes["29"] = "Invalid aptNum" />
<cfset variables.ProPayStatusCodes["30"] = "Invalid city" />
<cfset variables.ProPayStatusCodes["31"] = "Invalid state" />
<cfset variables.ProPayStatusCodes["32"] = "Invalid billZip" />
<cfset variables.ProPayStatusCodes["33"] = "Invalid mailAddr" />
<cfset variables.ProPayStatusCodes["34"] = "Invalid mailApt" />
<cfset variables.ProPayStatusCodes["35"] = "Invalid mailCity" />
<cfset variables.ProPayStatusCodes["36"] = "Invalid mailState" />
<cfset variables.ProPayStatusCodes["37"] = "Invalid mailZip" />
<cfset variables.ProPayStatusCodes["38"] = "Invalid dayPhone" />
<cfset variables.ProPayStatusCodes["39"] = "Invalid evenPhone" />
<cfset variables.ProPayStatusCodes["40"] = "Invalid ssn" />
<cfset variables.ProPayStatusCodes["41"] = "Invalid dob" />
<cfset variables.ProPayStatusCodes["42"] = "Invalid recEmail" />
<cfset variables.ProPayStatusCodes["43"] = "Invalid knownAccount" />
<cfset variables.ProPayStatusCodes["44"] = "Invalid amount" />
<cfset variables.ProPayStatusCodes["45"] = "Invalid invNum" />
<cfset variables.ProPayStatusCodes["46"] = "Invalid rtNum" />
<cfset variables.ProPayStatusCodes["47"] = "Invalid accntNum" />
<cfset variables.ProPayStatusCodes["48"] = "Invalid ccNum" />
<cfset variables.ProPayStatusCodes["49"] = "Invalid expDate" />
<cfset variables.ProPayStatusCodes["50"] = "Invalid cvv2" />
<cfset variables.ProPayStatusCodes["51"] = "Invalid transNum or unavailable to act on transNum due to funding" />
<cfset variables.ProPayStatusCodes["52"] = "Invalid splitNum" />
<cfset variables.ProPayStatusCodes["53"] = "A ProPay account with this e-mail address already exists or User has no AccountNumber" />
<cfset variables.ProPayStatusCodes["54"] = "A ProPay account with this social security number already exists" />
<cfset variables.ProPayStatusCodes["55"] = "The email address provided does not correspond to a ProPay account" />
<cfset variables.ProPayStatusCodes["56"] = "Recipient’s e-mail address shouldn’t have a ProPay account and does" />
<cfset variables.ProPayStatusCodes["57"] = "Cannot settle transaction because it already expired" />
<cfset variables.ProPayStatusCodes["58"] = "Credit card declined (the responseCode element will provide info on the decline reason)" />
<cfset variables.ProPayStatusCodes["59"] = "Invalid Credential or IP address not allowed" />
<cfset variables.ProPayStatusCodes["60"] = "Credit card authorization timed out; retry at a later time" />
<cfset variables.ProPayStatusCodes["61"] = "Amount exceeds single transaction limit" />
<cfset variables.ProPayStatusCodes["62"] = "Amount exceeds monthly volume limit" />
<cfset variables.ProPayStatusCodes["63"] = "Insufficient funds in account" />
<cfset variables.ProPayStatusCodes["64"] = "Over credit card use limit" />
<cfset variables.ProPayStatusCodes["65"] = "Miscellaneous error" />
<cfset variables.ProPayStatusCodes["66"] = "Denied a ProPay account" />
<cfset variables.ProPayStatusCodes["67"] = "Unauthorized service requested" />
<cfset variables.ProPayStatusCodes["68"] = "Account not affiliated" />
<cfset variables.ProPayStatusCodes["69"] = "Duplicate invoice number (The same card was charged for the same amount with the same invoice number (including a blank invoice number) in a 1 hour period" />
<cfset variables.ProPayStatusCodes["70"] = "Duplicate external ID" />
<cfset variables.ProPayStatusCodes["71"] = "Account previously set up, but problem affiliating it with partner" />
<cfset variables.ProPayStatusCodes["72"] = "The ProPay Account has already been upgraded to a Premium Account" />
<cfset variables.ProPayStatusCodes["73"] = "Invalid Destination Account" />
<cfset variables.ProPayStatusCodes["74"] = "Account or Trans Error" />
<cfset variables.ProPayStatusCodes["75"] = "Money already pulled" />
<cfset variables.ProPayStatusCodes["76"] = "Not Premium" />
<cfset variables.ProPayStatusCodes["77"] = "Empty results" />
<cfset variables.ProPayStatusCodes["78"] = "Invalid Authentication" />
<cfset variables.ProPayStatusCodes["79"] = "Generic account status error" />
<cfset variables.ProPayStatusCodes["80"] = "Invalid Password" />
<cfset variables.ProPayStatusCodes["81"] = "AccountExpired" />
<cfset variables.ProPayStatusCodes["82"] = "InvalidUserID" />
<cfset variables.ProPayStatusCodes["83"] = "BatchTransCountError" />
<cfset variables.ProPayStatusCodes["84"] = "InvalidBeginDate" />
<cfset variables.ProPayStatusCodes["85"] = "InvalidEndDate" />
<cfset variables.ProPayStatusCodes["86"] = "InvalidExternalID" />
<cfset variables.ProPayStatusCodes["87"] = "DuplicateUserID" />
<cfset variables.ProPayStatusCodes["88"] = "Invalid track 1" />
<cfset variables.ProPayStatusCodes["89"] = "Invalid track 2" />
<cfset variables.ProPayStatusCodes["90"] = "Transaction already refunded" />
<cfset variables.ProPayStatusCodes["91"] = "Duplicate Batch ID" />
<cfset variables.ProPayStatusCodes["92"] = "Duplicate Batch Transaction" />
<cfset variables.ProPayStatusCodes["93"] = "Batch Transaction amount error" />
<cfset variables.ProPayStatusCodes["94"] = "Unavailable Tier" />
<cfset variables.ProPayStatusCodes["95"] = "Invalid Country Code" />
<cfset variables.ProPayStatusCodes["97"] = "Account created in documentary status, but still must be validated" />
<cfset variables.ProPayStatusCodes["98"] = "Account created in documentary status, but still must be validated and paid for" />
<cfset variables.ProPayStatusCodes["99"] = "Account created successfully, but still must be paid for" />
<cfset variables.ProPayStatusCodes["100"] = "Transaction Already Refunded" />
<cfset variables.ProPayStatusCodes["101"] = "Refund Exceeds Original Transaction" />
<cfset variables.ProPayStatusCodes["102"] = "Invalid Payer Name" />
<cfset variables.ProPayStatusCodes["103"] = "Transaction does not meet date criteria" />
<cfset variables.ProPayStatusCodes["104"] = "Transaction could not be refunded due to current transaction state" />
<cfset variables.ProPayStatusCodes["105"] = "Direct deposit account not specified" />
<cfset variables.ProPayStatusCodes["106"] = "Invalid SEC code" />
<cfset variables.ProPayStatusCodes["107"] = "Invalid Account Name (ACH account)" />
<cfset variables.ProPayStatusCodes["108"] = "Invalid x509 certificate" />
<cfset variables.ProPayStatusCodes["109"] = "Invalid value for require CC refund" />
<cfset variables.ProPayStatusCodes["110"] = "Required field is missing" />
<cfset variables.ProPayStatusCodes["111"] = "Invalid EIN" />
<cfset variables.ProPayStatusCodes["112"] = "Invalid business legal name (DBA)" />
<cfset variables.ProPayStatusCodes["113"] = "One of the business legal address fields is invalid" />
<cfset variables.ProPayStatusCodes["114"] = "Business (legal) city is invalid" />
<cfset variables.ProPayStatusCodes["115"] = "Business (legal) state is invalid" />
<cfset variables.ProPayStatusCodes["116"] = "Business (legal) zip is invalid" />
<cfset variables.ProPayStatusCodes["117"] = "Business (legal) country is invalid" />
<cfset variables.ProPayStatusCodes["118"] = "Mailing address invalid" />
<cfset variables.ProPayStatusCodes["119"] = "Business (legal) address is invalid" />
<cfset variables.ProPayStatusCodes["120"] = "Incomplete business address" />
<cfset variables.ProPayStatusCodes["121"] = "Amount Encumbered by enhanced Spendback" />
<cfset variables.ProPayStatusCodes["122"] = "Invalid encrypting device type" />
<cfset variables.ProPayStatusCodes["123"] = "Invalid key serial number" />
<cfset variables.ProPayStatusCodes["124"] = "Invalid encrypted track data" />
<cfset variables.ProPayStatusCodes["125"] = "You may not transfer money between these two accounts. Sponsor bank transfer disallowed" />
<cfset variables.ProPayStatusCodes["126"] = "Currency code not allowed for this transaction" />
<cfset variables.ProPayStatusCodes["127"] = "Currency code not permitted for this account" />

<cfset variables.ProPayResponseCodes["00"] = "Success" />
<cfset variables.ProPayResponseCodes["01"] = "Transaction blocked by issuer" />
<cfset variables.ProPayResponseCodes["04"] = "Pick up Card and deny transaction" />
<cfset variables.ProPayResponseCodes["05"] = "Problem with the account" />
<cfset variables.ProPayResponseCodes["06"] = "Customer requested stop to recurring payment" />
<cfset variables.ProPayResponseCodes["07"] = "Customer requested stop to all recurring payments" />
<cfset variables.ProPayResponseCodes["08"] = "Honor with ID only" />
<cfset variables.ProPayResponseCodes["09"] = "Unpaid items on customer account" />
<cfset variables.ProPayResponseCodes["12"] = "Invalid transaction" />
<cfset variables.ProPayResponseCodes["13"] = "Amount Error" />
<cfset variables.ProPayResponseCodes["14"] = "Invalid card number" />
<cfset variables.ProPayResponseCodes["15"] = "No such issuer. Could not route transaction" />
<cfset variables.ProPayResponseCodes["16"] = "refund error" />
<cfset variables.ProPayResponseCodes["17"] = "Over limit" />
<cfset variables.ProPayResponseCodes["19"] = "re enter transaction or the merchant account may be boarded incorrectly" />
<cfset variables.ProPayResponseCodes["25"] = "Invalid terminal" />
<cfset variables.ProPayResponseCodes["41"] = "Lost card" />
<cfset variables.ProPayResponseCodes["43"] = "Stolen card" />
<cfset variables.ProPayResponseCodes["51"] = "Insufficient funds" />
<cfset variables.ProPayResponseCodes["52"] = "No such account" />
<cfset variables.ProPayResponseCodes["54"] = "Expired card" />
<cfset variables.ProPayResponseCodes["55"] = "Incorrect PIN" />
<cfset variables.ProPayResponseCodes["57"] = "Bank does not allow this type of purchase" />
<cfset variables.ProPayResponseCodes["58"] = "Credit card network does not allow this type of purchase for your merchant account" />
<cfset variables.ProPayResponseCodes["61"] = "Exceeds issuer withdrawal limit" />
<cfset variables.ProPayResponseCodes["62"] = "Issuer does not allow this card to be charged for your business" />
<cfset variables.ProPayResponseCodes["63"] = "Security Violation" />
<cfset variables.ProPayResponseCodes["65"] = "Activity limit exceeded" />
<cfset variables.ProPayResponseCodes["75"] = "PIN tries exceeded" />
<cfset variables.ProPayResponseCodes["76"] = "Unable to locate account" />
<cfset variables.ProPayResponseCodes["78"] = "Account not recognized" />
<cfset variables.ProPayResponseCodes["80"] = "Invalid Date" />
<cfset variables.ProPayResponseCodes["82"] = "Invalid CVV2" />
<cfset variables.ProPayResponseCodes["83"] = "Cannot verify the PIN" />
<cfset variables.ProPayResponseCodes["85"] = "Service not supported for this card" />
<cfset variables.ProPayResponseCodes["93"] = "Cannot complete transaction. Customer should call 800 number" />
<cfset variables.ProPayResponseCodes["96"] = "Issuer system malfunction or timeout" />
<cfset variables.ProPayResponseCodes["97"] = "Approved for a lesser amount. This is considered a decline" />
<cfset variables.ProPayResponseCodes["98"] = "Failure HV" />
<cfset variables.ProPayResponseCodes["99"] = "Unable to parse issuer response code. Generic decline" />

<cfscript>
	oAdmin = createObject("component", "cfide.adminapi.base");

	oAdmin.dump(getDirectoryFromPath( getCurrentTemplatePath() ));

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
					<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
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
								<payerName>Jane Doe</payerName> 
								<Comment1>This is a sales order</Comment1> 
								<Comment2>Nothing else.</Comment2> 
								<result></result> 
								<InvoiceExternalRefNum></InvoiceExternalRefNum> 
								<initialTransactionResult></initialTransactionResult> 
							</XMLTrans> 
						</XMLTransactions>
					</XMLResponse>';

	results = xmlParse(str1);
	structSetters = {};

	try 
	{
		transactionResult = XmlSearch(results,"//XMLTrans");

		if ( isarray(transactionResult) && arraylen(transactionResult) ) 
		{

				if ( structkeyexists(transactionResult[1], "XMLChildren") && ( isarray(transactionResult[1].XMLChildren) && arraylen(transactionResult[1].XMLChildren) ) )
				{

					arrayParameters = transactionResult[1].XMLChildren;
					
					for ( i=1; i <= arraylen(arrayParameters); i++ )
					{
						
						if ( arrayParameters[i].XmlName == "status" && structkeyexists(variables.ProPayStatusCodes,arrayParameters[i].XmlText) )
						{	
							structSetters["setMessage"] = variables.ProPayStatusCodes[arrayParameters[i].XmlText];
							// local.processorData.setMessage(variables.ProPayStatusCodes[arrayParameters[i].XmlText]);
						}

						if ( arrayParameters[i].XmlName == "ResponseCode" && structkeyexists(variables.ProPayResponseCodes,arrayParameters[i].XmlText) )
						{
							structSetters["setMessage"] = variables.ProPayResponseCodes[arrayParameters[i].XmlText];
							// local.processorData.setMessage(variables.ProPayResponseCodes[arrayParameters[i].XmlText]);
						}

						if ( arrayParameters[i].XmlName == "transNum" )
						{
							structSetters["setTransactionID"] = arrayParameters[i].XmlText;
							// local.processorData.setTransactionID(arrayParameters[i].XmlText);
						}

						if ( arrayParameters[i].XmlName == "AVS" )
						{
							structSetters["setAVSCode"] = arrayParameters[i].XmlText;
							// local.processorData.setAVSCode(arrayParameters[i].XmlText);
						}

						if ( arrayParameters[i].XmlName == "status" )
						{
							switch (arrayParameters[i].XmlText) 
							{
								case "00": 
								{
									structSetters["setStatus"] = arrayParameters[i].XmlText;
									// local.processorData.setStatus(getService().getStatusSuccessful());
									break;
								}
								case "58": 
								{
									structSetters["setStatus"] = arrayParameters[i].XmlText;
									// local.processorData.setStatus(getService().getStatusDeclined());
									break;
								}
								case "48": 
								{
									structSetters["setStatus"] = arrayParameters[i].XmlText;
									// local.processorData.setStatus(getService().getStatusDeclined());
									break;
								}
								default: 
								{
									structSetters["setStatus"] = arrayParameters[i].XmlText;
									// local.processorData.setStatus(getService().getStatusFailure());
									break;
								}
							}
						}
					}
				}
				else
				{
					WriteOutput("XMLSearch worked fine, but there were no children");
				}



				oAdmin.dump(structSetters);


		}
	}
	catch(Any e) 
	{
		oAdmin.dump(e);
	}
</cfscript>