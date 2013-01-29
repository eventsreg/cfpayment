<cfcomponent displayname="ProPay Interface" extends="cfpayment.api.gateway.base" hint="ProPay Gateway (integrated XML interface)" output="false">
	<cfset variables.cfpayment.GATEWAY_NAME = "ProPay" />
	<cfset variables.cfpayment.GATEWAY_VERSION = "5.3.1" />
	<cfset variables.cfpayment.GATEWAY_LIVE_URL = "https://epay.propay.com/api/propayapi.aspx" />
	<cfset variables.cfpayment.GATEWAY_TEST_URL = "https://xmltest.propay.com/api/propayapi.aspx" />
	
	<cfset variables.ProPay = {} />
	<cfset variables.ProPay["00"] = "Success" />
	<cfset variables.ProPay["01"] = "Transaction blocked by issuer" />
	<cfset variables.ProPay["04"] = "Pick up Card and deny transaction" />
	<cfset variables.ProPay["05"] = "Problem with the account" />
	<cfset variables.ProPay["06"] = "Customer requested stop to recurring payment" />
	<cfset variables.ProPay["07"] = "Customer requested stop to all recurring payments" />
	<cfset variables.ProPay["08"] = "Honor with ID only" />
	<cfset variables.ProPay["09"] = "Unpaid items on customer account" />
	<cfset variables.ProPay["12"] = "Invalid transaction" />
	<cfset variables.ProPay["13"] = "Amount Error" />
	<cfset variables.ProPay["14"] = "Invalid card number" />
	<cfset variables.ProPay["15"] = "No such issuer. Could not route transaction" />
	<cfset variables.ProPay["16"] = "refund error" />
	<cfset variables.ProPay["17"] = "Over limit" />
	<cfset variables.ProPay["19"] = "re enter transaction or the merchant account may be boarded incorrectly" />
	<cfset variables.ProPay["25"] = "Invalid terminal" />
	<cfset variables.ProPay["41"] = "Lost card" />
	<cfset variables.ProPay["43"] = "Stolen card" />
	<cfset variables.ProPay["51"] = "Insufficient funds" />
	<cfset variables.ProPay["52"] = "No such account" />
	<cfset variables.ProPay["54"] = "Expired card" />
	<cfset variables.ProPay["55"] = "Incorrect PIN" />
	<cfset variables.ProPay["57"] = "Bank does not allow this type of purchase" />
	<cfset variables.ProPay["58"] = "Credit card network does not allow this type of purchase for your merchant account" />
	<cfset variables.ProPay["61"] = "Exceeds issuer withdrawal limit" />
	<cfset variables.ProPay["62"] = "Issuer does not allow this card to be charged for your business" />
	<cfset variables.ProPay["63"] = "Security Violation" />
	<cfset variables.ProPay["65"] = "Activity limit exceeded" />
	<cfset variables.ProPay["75"] = "PIN tries exceeded" />
	<cfset variables.ProPay["76"] = "Unable to locate account" />
	<cfset variables.ProPay["78"] = "Account not recognized" />
	<cfset variables.ProPay["80"] = "Invalid Date" />
	<cfset variables.ProPay["82"] = "Invalid CVV2" />
	<cfset variables.ProPay["83"] = "Cannot verify the PIN" />
	<cfset variables.ProPay["85"] = "Service not supported for this card" />
	<cfset variables.ProPay["93"] = "Cannot complete transaction. Customer should call 800 number" />
	<cfset variables.ProPay["96"] = "Issuer system malfunction or timeout" />
	<cfset variables.ProPay["97"] = "Approved for a lesser amount. This is considered a decline" />
	<cfset variables.ProPay["98"] = "Failure HV" />
	<cfset variables.ProPay["99"] = "Unable to parse issuer response code. Generic decline" />


	<cffunction name="process" output="false" access="private" returntype="any" hint="This is main conduit for the gateway.">
		<cfargument name="payload" type="string" required="true" />

		<!---  
				Response from purchase():

				<?xml version="1.0" encoding="utf-8" standalone="no"?> 
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
				</XMLResponse>

				If ACH is used:

				<?xml version="1.0" encoding="utf-8" standalone="no"?> 
				<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
					<XMLTrans> 
						<transType>36</transType> 
						<accountNum>1547785</accountNum> 
						<invNum>ach1</invNum> 
						<status>00</status> 
						<transNum>1820</transNum> 
					</XMLTrans>
				</XMLResponse>
				
				-------------------------------

				Response from authorize():

				<?xml version="1.0" encoding="utf-8" standalone="no"?> 
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

				-------------------------------

				Response from capture():

				<?xml version="1.0" encoding="utf-8" standalone="no"?> 
				<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
					<XMLTrans> 
						<transType>06</transType>
						<transNum>477263</transNum> 
						<status>57</status> 
					</XMLTrans>
				</XMLResponse>

				-------------------------------
				
				Response from void() or credit():

				<?xml version="1.0" encoding="utf-8" standalone="no"?> 
				<XMLResponse xmlns:xsi="http://www.w3.org/2000/10/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.propay.com/schema/PPResponse.xsd">
					<XMLTrans> 
						<transType>07</transType> 
						<accountNum>3130000</accountNum> 
						<transNum>453123</transNum> 
						<status>00</status> 
					</XMLTrans>
				</XMLResponse>

				-------------------------------

				Response from status():
				(can take either a cardholder name or a transaction id)

				<?xml version="1.0" standalone="no"?> 
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
				</XMLResponse>
		--->

		<cfscript>
			local = {};
			results = "";
			transactionResult = "";
			
			local.p = arguments.payload.trim();
			local.h["Content-Type"] = "text/xml";
			local.h["Content-Length"] = len(local.p);
			
			local.processorData = createResponse(argumentCollection = super.process(payload = local.p, headers=local.h));
			
			if ( not local.processorData.hasError() ) 
			{
				if ( len(local.processorData.getResult()) > 0 && isXML(local.processorData.getResult()) ) 
				{
					
					results = xmlParse(local.processorData.getResult());
					local.processorData.setParsedResult(results);
					
					try 
					{
						transactionResult = XmlSearch(results,"//:XMLTrans");

						if ( isarray(transactionResult) && arraylen(transactionResult) == 1 ) 
						{

							if ( structkeyexists(transactionResult[1], "Result") && structkeyexists(variables.ProPay,transactionResult[1].Result.xmlText) ) 
							{
								local.processorData.setMessage(variables.ProPay[transactionResult[1].Result.xmlText]);
							}
							else if ( structkeyexists(transactionResult[1], "Message") ) 
							{
								local.processorData.setMessage(transactionResult[1].Message.xmlText);
							}
							else
							{
								local.processorData.setMessage("No message found.");
							}
							
							if ( structkeyexists(transactionResult[1], "PNRef") ) 
							{
								local.processorData.setTransactionID(transactionResult[1].PNRef.xmlText);
							}
							
							if ( structkeyexists(transactionResult[1], "AuthCode") ) 
							{
								local.processorData.setAuthorization(transactionResult[1].AuthCode.xmlText);
							}
							
							if ( structkeyexists(transactionResult[1],"AVSResult") ) 
							{
								local.processorData.setAVSCode(transactionResult[1].AVSResult.xmlText);
							}
							
							if ( structkeyexists(transactionResult[1], "Result") ) 
							{
								switch (transactionResult[1].Result.xmlText) 
								{
									case "0": 
									{
										local.processorData.setStatus(getService().getStatusSuccessful());
										break;
									}
									case "12": 
									{
										local.processorData.setStatus(getService().getStatusDeclined());
										break;
									}
									case "23": 
									{
										local.processorData.setStatus(getService().getStatusDeclined());
										break;
									}
									case "126": 
									{
										local.processorData.setStatus(getService().getStatusSuccessful());
										break;
									}
									default: 
									{
										local.processorData.setStatus(getService().getStatusFailure());
										break;
									}
								}
							}
						}
						else
						{
							local.processorData.setStatus(getService().getStatusUnknown());
							local.processorData.setMessage("Required Xml node missing from transaction response or there were too many of the necessary Xml node(s). [#arraylen(transactionResult)#]");
						}
					}
					catch(Any e) 
					{
						local.processorData.setStatus(getService().getStatusUnknown());
						local.processorData.setMessage("Required Xml node missing from transaction response or an error was thrown (#e#)");
					}
				}
				else
				{
					local.processorData.setStatus(getService().getStatusFailure());
					local.processorData.setMessage("Required Xml payload is completely missing from transaction response.");
				}
			}

			return local.processorData;
		</cfscript>
	</cffunction>

	<cffunction name="purchase" output="false" access="public" returntype="any" hint="Transaction: Sale">
		<cfargument name="money" type="any" required="true" />
		<cfargument name="account" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />
		<cfset var invoiceNumber = "" />

		<cfif structkeyexists(arguments.options, "invoiceNumber")>
			<cfset invoiceNumber = arguments.options["invoiceNumber"] />
		</cfif>
		
		<cfswitch expression="#lcase(listLast(getMetaData(arguments.account).fullname, "."))#">
			<cfcase value="creditcard">
				<!---// transType for this is always 04 //--->
				<cfoutput>
					<cfxml variable="xmlRequest">
						<?xml version='1.0'?> 
						<!DOCTYPE Request.dtd> 
						<XMLRequest> 
							<certStr>#getPassword()#</certStr> 
							<class>partner</class>
							<XMLTrans> 
								<transType>04</transType> 
								<amount>#arguments.money.getAmount()#</amount> 
								<addr>#xmlFormat(arguments.account.getAddress())#</addr> 
								<zip>#xmlFormat(arguments.account.getPostalCode())#</zip> 
								<accountNum>#getUsername()#</accountNum> 
								<ccNum>#arguments.account.getAccount()#</ccNum> 
								<expDate>#arguments.account.getMonth()##arguments.account.getYear()#</expDate> 
								<CVV2>#xmlformat(arguments.account.getVerificationValue())#</CVV2> 
								<cardholderName>#xmlformat(arguments.account.getFirstName() & " " & arguments.account.getLastName())#</cardholderName> 
								<invNum>#invoiceNumber#</invNum> 
								<billPay>N</billPay> 
							</XMLTrans>
						</XMLRequest>
					</cfxml>
				</cfoutput>
			</cfcase>
			<cfcase value="eft">
				<cfoutput>
					<cfxml variable="xmlRequest">
						<?xml version='1.0'?> 
						<!DOCTYPE Request.dtd> 
						<XMLRequest> 
							<certStr>#getPassword()#</certStr> 
							<class>partner</class>
							<XMLTrans> 
								<transType>36</transType> 
								<amount>#arguments.money.getAmount()#</amount> 
								<accountNum>#getUsername()#</accountNum>
								<RoutingNumber>#xmlformat(arguments.account.getRoutingNumber())#</RoutingNumber> 
								<AccountNumber>#xmlformat(arguments.account.getAccount())#</AccountNumber> 
								<accountType>#xmlformat(arguments.account.getAccountType())#</accountType> 
								<StandardEntryClassCode>WEB</StandardEntryClassCode> 
								<accountName>Personal Account</accountName> 
								<invNum>ach1</invNum>
							</XMLTrans> 
						</XMLRequest>
					</cfxml>
				</cfoutput>
			</cfcase>
			<cfdefaultcase>
				<cfthrow type="cfpayment.InvalidAccount" message="The account type #lcase(listLast(getMetaData(arguments.account).fullname, "."))# is not supported by this gateway." />
			</cfdefaultcase>
		</cfswitch>

		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="authorize" output="false" access="public" returntype="any" hint="Credit Card Authorization Only">
		<cfargument name="money" type="any" required="true" />
		<cfargument name="account" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />
		<cfset var invoiceNumber = "" />

		<cfif structkeyexists(arguments.options, "invoiceNumber")>
			<cfset invoiceNumber = arguments.options["invoiceNumber"] />
		</cfif>

		<!---// transType for this is always 05 //--->

		<cfoutput>
			<cfxml variable="xmlRequest">
				<?xml version='1.0'?> 
				<!DOCTYPE Request.dtd> 
				<XMLRequest> 
					<certStr>#getPassword()#</certStr> 
					<class>partner</class>
					<XMLTrans> 
						<transType>05</transType> 
						<amount>#arguments.money.getAmount()#</amount> 
						<accountNum>#getUsername()#</accountNum> 
						<ccNum>#arguments.account.getAccount()#</ccNum> 
						<expDate>#arguments.account.getMonth()##arguments.account.getYear()#</expDate> 
						<invNum>#invoiceNumber#</invNum> 
						<billPay>N</billPay> 
					</XMLTrans>
				</XMLRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="capture" output="false" access="public" returntype="any" hint="Credit Card Capture">
		<cfargument name="money" type="any" required="true" />
		<cfargument name="authorization" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />

		<cfoutput>
			<cfxml variable="xmlRequest">
				<?xml version='1.0'?> 
				<!DOCTYPE Request.dtd> 
				<XMLRequest> 
					<certStr>#getPassword()#</certStr> 
					<class>partner</class>
					<XMLTrans> 
						<transType>06</transType> 
						<accountNum>#getUsername()#</accountNum> 
						<transNum>#xmlformat(arguments.authorization)#</transNum> 
					</XMLTrans>
				</XMLRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="void" output="false" access="public" returntype="any" hint="Void Credit Card Authorization">
		<cfargument name="id" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />
		<cfset var invoiceNumber = "" />

		<!---// transType for this is always 06 //--->

		<cfif structkeyexists(arguments.options, "invoiceNumber")>
			<cfset invoiceNumber = arguments.options["invoiceNumber"] />
		</cfif>

		<cfoutput>
			<cfxml variable="xmlRequest">
				<?xml version='1.0'?> 
				<!DOCTYPE Request.dtd> 
				<XMLRequest> 
					<certStr>#getPassword()#</certStr> 
					<class>partner</class>
					<XMLTrans>
						<transType>07</transType> 
						<accountNum>#getUsername()#</accountNum> 
						<transNum>#xmlformat(arguments.id)#</transNum> 
						<amount>#arguments.money.getAmount()#</amount> 
						<invNum>#invoiceNumber#</invNum> 
					</XMLTrans>
				</XMLRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>

	<cffunction name="credit" output="false" access="public" returntype="any" hint="Credit Card Refund">
		<cfargument name="money" type="any" required="true" />
		<cfargument name="transactionid" type="any" required="true" />
		<cfargument name="account" type="any" required="false" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />
		<cfset var invoiceNumber = "" />

		<!---// transType for this is always 07 //--->

		<cfif structkeyexists(arguments.options, "invoiceNumber")>
			<cfset invoiceNumber = arguments.options["invoiceNumber"] />
		</cfif>

		<cfoutput>
			<cfxml variable="xmlRequest">
				<?xml version='1.0'?> 
				<!DOCTYPE Request.dtd> 
				<XMLRequest> 
					<certStr>#getPassword()#</certStr> 
					<class>partner</class>
					<XMLTrans>
						<transType>07</transType> 
						<accountNum>#getUsername()#</accountNum> 
						<transNum>#xmlformat(arguments.transactionid)#</transNum> 
						<amount>#arguments.money.getAmount()#</amount> 
						<invNum>#invoiceNumber#</invNum> 
					</XMLTrans>
				</XMLRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="status" output="false" access="public" returntype="any" hint="Transaction Lookup">
		<cfargument name="transactionid" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />

		<!---// transType for this is always 34 //--->

		<cfoutput>
			<cfxml variable="xmlRequest">
				<?xml version='1.0'?> 
				<!DOCTYPE Request.dtd> 
				<XMLRequest> 
					<certStr>#getPassword()#</certStr> 
					<class>partner</class>
					<XMLTrans> 
						<transType>34</transType> 
						<accountNum>#getUsername()#</accountNum>
						<cfif structkeyexists(arguments.options, "cardholder")>
							<payerName>#arguments.options["cardHolder"]#</payerName>
						<cfelse>
							<transNum>#xmlformat(arguments.transactionid)#</transNum>
						</cfif>
					</XMLTrans>
				</XMLRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<!---// Helper methods //--->
	<cffunction name="throw" output="true" access="public" hint="Script version of CF tag: CFTHROW">
		<cfargument name="message" required="no" default="" />
		<cfargument name="detail" required="no" default="" />
		<cfargument name="type" required="no" />
		
		<cfif not isSimpleValue(arguments.message)>
			<cfsavecontent variable="arguments.message">
				<cfdump var="#arguments.message#" />
			</cfsavecontent>
		</cfif>
		
		<cfif not isSimpleValue(arguments.detail)>
			<cfsavecontent variable="arguments.detail">
				<cfdump var="#arguments.detail#" />
			</cfsavecontent>
		</cfif>
		
		<cfif structkeyexists(arguments, "type")>
			<cfthrow message="#arguments.message#" detail="#arguments.detail#" type="#arguments.type#" />
		<cfelse>
			<cfthrow message="#arguments.message#" detail="#arguments.detail#" />
		</cfif>
	</cffunction>
	
	<!---//
	$Id: propay.cfc 000 2013-01-29 02:24:23Z jasonb $
	
	Copyright 2013 Jason Brookins (http://www.jasonbrookins.com/)
		
	Licensed under the Apache License, Version 2.0 (the "License"); you 
	may not use this file except in compliance with the License. You may 
	obtain a copy of the License at:
	 
		http://www.apache.org/licenses/LICENSE-2.0
		 
	Unless required by applicable law or agreed to in writing, software 
	distributed under the License is distributed on an "AS IS" BASIS, 
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
	See the License for the specific language governing permissions and 
	limitations under the License.


	Test URL is: https://xmltest.propay.com/API/PropayAPI.aspx
	Production URL is: https://epay.propay.com/api/propayapi.aspx

	//--->
	
</cfcomponent>