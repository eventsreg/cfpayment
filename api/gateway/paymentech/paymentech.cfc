<cfcomponent displayname="Paymentech Interface" extends="cfpayment.api.gateway.base" hint="Chase Paymentech Gateway (integrated XML interface)" output="false">
	<cfset variables.cfpayment.GATEWAY_NAME = "Paymentech" />
	<cfset variables.cfpayment.GATEWAY_VERSION = "" />
	<cfset variables.cfpayment.GATEWAY_LIVE_URL = "" />
	<cfset variables.cfpayment.GATEWAY_TEST_URL = "" />

	<!---//  
			Notes:

			Chase Paymentech exposes redundant hostname/port network endpoints to ensure high availability for the Orbital Gateway. 
			To maximize availability, Developers should code to detect connectivity issues and HTTP errors, and temporarily switch to a failover URL. 
			Failover to the secondary hostname/port must be automatic and completely transparent to the end-user. Communication with the primary 
			hostname/port should be attempted periodically while in a state of failover.

			Orbital Gateway certification system: 
				Primary:	orbitalvar1.paymentech.net/authorize on port 443 
				Secondary:	orbitalvar2.paymentech.net/authorize on port 443
			Orbital Gateway production system: 
				Primary:	orbital1.paymentech.net/authorize on port 443 
				Secondary:	orbital2.paymentech.net/authorize on port 443

			The Orbital Gateway will only provide responses to HTTP POST requests. The POST method is used to request that the origin server accept the 
			entity enclosed in the request as a new subordinate of the resource identified by the Request-URI in the Request-Line. Orbital Gateway does 
			not support GET requests.

			Platforms:
				- BIN 000001 (Salem): Visa, MasterCard, MasterCard Diners, International Maestro
				- BIN 000002 (Tampa): Visa, MasterCard, MasterCard Diners, Discover, American Express

			Response:

			When successfully interacting with the Orbital Gateway, the HTTP value returned will always be a 200 response, such as HTTP/1.0 200 OK. 
			All other responses indicate some sort of connection problem. A HTTP 200 response in and of itself does not constitute a good response—it 
			simply means that the connection has successfully been established with the Orbital Gateway.

			Transaction types supported:
			
			New Order:
				Authorization (Auth Only) : Authorize the supplied information, but do NOT create a settlement item. This transaction type should be used for deferred billing transactions.
				Authorization and Capture (Sale) : Authorize the supplied information and mark it as captured for next settlement cut. This transaction should be used for immediate fulfillment.
				Force and Capture : Force transactions do not generate new authorizations. A good response simply indicates that the request has been properly formatted. The Orbital Gateway will settle the captured force during the next settlement event.
				Refund (Return/Credit) : Instruct the Gateway to generate a refund based on the supplied information.
				Refund via Transaction Reference Number : A Refund can be generated for a previous charge using the TxRefNum of the original transaction. If no amount is sent, the original transaction amount is refunded. If an amount is sent, that amount must be equal to or less than the original amount.
	
			Profile:
				Add a Profile 
				Delete a Profile 
				Update a Profile 
				Retrieve a profile

			Mark for Capture (MFC):
				Mark a previously authorized transaction as being ready to be submitted for clearing. The Mark for Capture transaction type is present for future fulfillment models. 
				A transaction can be authorized now and marked for capture at any time in the next four months. The Mark for Capture can be for any amount less than or equal to the original authorization. If the amount is less than the original auth, this is treated as a split transaction.
				The split transaction also results in the creation of a new order for the balance left over from the original authorization. Adjustments to the original transaction, such as Level 2 and 3 data or amount, are also made, as required. Upon marking a portion or the remainder of 
				the split transaction, the system will automatically attempt to obtain a new authorization for the new order.

			Reversal (Void a Previous Transaction):
				This transaction is for voiding a previous transaction, either in the full amount or partial amount. It can be extended to also reverse the original authorization at the issuer.
				A void, in and of itself, does not reverse the original authorization for any card type other than Gift Card and PINless Debit. When extending the void request to include an 
				authorization reversal, the hold on the accountholder’s open-to-buy (line-of-credit), which was reserved by the original authorization, is freed up. It is important to note that 
				it is at the Issuer’s discretion whether or not to remove the hold.
				
				- Transaction must not have been settled.
				- Transaction Reference Number from the response message of the original request must be provided. If the Transaction Reference Number is not known, merchants can submit in its place the Retry Trace Number of the original request within the <ReversalRetryNumber> element.
				- Full or a partial amount must be submitted. A void for a partial amount creates a split of the original transaction into two components. A voided transaction in the amount of the partial void request and the remainder of the previous transaction in the same state the full amount was previously in (Authorized or Marked for Capture).

			Inquiry:
				An Inquiry transaction returns the response of any specified request. This is useful when a merchant needs to know the result of a transaction in the case of, for example, a communication error or unexpected result. An InquiryRetryNumber value, which corresponds to the Retry Trace Number of the originating transaction, must be passed 
				in the Inquiry request message in order to obtain the response. If there is no matching result, an error message is returned. Similar to the Retry Trace Number, the Inquiry Retry Number is valid within a 48-hour window from the time of the original transaction.
				The basic process flow for an Inquiry is as follows:
				1.	A transaction is submitted with a Retry Trace Number and Merchant ID in the request.
				2.	The merchant does not receive a response and subsequently submits an inquiry using the Retry Trace Number (as the Inquiry Retry Number) and Merchant ID.
				3.	The Gateway validates the Inquiry Retry Number and Merchant ID to determine if it has processed a transaction using that value pair within a 48-hour window.
				4.	The Gateway returns the transaction response details for the original request, if the transaction was found.

			Quick Response:
				When a transaction has an error condition, such as a time out condition or a poorly formed message request, the gateway will generate a quick error message back to the requestor. This error response takes the form of a “Quick Response”.

			CVV:

				Verify that the Merchant Plug-in will provide the CAVV and or AAV in Base 64 encoding before sending to Chase Paymentech. If not, merchants must convert to Base 64 before sending to Chase Paymentech.
			
			Retry Logic:

			Retry Logic is a function available from the Orbital Gateway for client interfaces to reprocess transactions when there is an unknown result on a XML transaction request. It is available to any merchant 
			interfacing to the Orbital Gateway using XML by simply adding two new values to the MIME-Header: the Merchant ID and a transaction Retry Trace Number. The Orbital Gateway uses this combination of values 
			to determine the uniqueness of a transaction in determining how to process the transaction.
			
			The result is that any Client properly utilizing Retry Logic can safely reprocess transactions with an unknown result while avoiding:
			- Risk of double-authorizing a transaction against a cardholder’s available balance. 
			- Duplication (or more) of settlement items.

			The basic process flow of Retry Logic is as follows:
			1.	A request is submitted with a Retry Trace Number and Merchant ID in the MIME-Header.
			2.	The Gateway validates the Retry Trace Number and Merchant ID to determine if it has processed a transaction using that value pair within the past 48-hour window.
			3.	If the transaction was declined or generated an error on the initial response, the next request is treated as a new request.
			4.	If it has not processed the pair, the Gateway treats that transaction as a new request and processes it accordingly.
			5.	If it has processed the pair and the request has either already been processed (the initial response is an approval) or is in process, the Orbital Gateway will immediately echo back the exact response from the initial request.
			
			If the initial request is still in process, the Orbital Gateway will block and wait until that original response is completed. As soon as that is done, it will then echo back the same response as the original request.

	//--->

	<!---//  
			New Order:

			<?xml version="1.0" encoding="UTF-8"?> 
			<Request>
				<NewOrder> 
					<OrbitalConnectionUsername>TESTUSER123</OrbitalConnectionUsername> 
					<OrbitalConnectionPassword>abcd1234</OrbitalConnectionPassword> 
					<IndustryType>EC</IndustryType> 
					<MessageType>AC</MessageType> 
					<BIN>000001</BIN> 
					<MerchantID>123456</MerchantID> 
					<TerminalID>001</TerminalID> 
					<CardBrand></CardBrand> 
					<AccountNum>5454545454545454</AccountNum> 
					<Exp>0112</Exp> 
					<CurrencyCode>840</CurrencyCode> 
					<CurrencyExponent>2</CurrencyExponent> 
					<AVSzip>25541</AVSzip> 
					<AVSaddress1>123 Test Street</AVSaddress1> 
					<AVSaddress2>Suite 350</AVSaddress2> 
					<AVScity>Test City</AVScity> 
					<AVSstate>FL</AVSstate> 
					<AVSphoneNum>8004564512</AVSphoneNum> 
					<OrderID>8316384413</OrderID> 
					<Amount>2500</Amount>
				</NewOrder> 
			</Request>



	//--->
	
	<cfset variables.PaymentechResponseCodes = {} /> <!--- <RespCode> values --->









	<cfset variables.PaymentechStatusCodes = {} />





	<cffunction name="process" output="false" access="private" returntype="any" hint="This is main conduit for the gateway.">
		<cfargument name="payload" type="string" required="true" />

		<!---//  
				New Order response:

				<?xml version="1.0" encoding="UTF-8"?> 
				<Response>
					<NewOrderResp> 
						<IndustryType/> 
						<MessageType>AC</MessageType> 
						<MerchantID>123456</MerchantID> 
						<TerminalID>001</TerminalID> 
						<CardBrand>MC</CardBrand> 
						<AccountNum>5454545454545454</AccountNum> 
						<OrderID>8316384413</OrderID> 
						<TxRefNum>48E0E5BC6EAB75C4863A09DFED9804E7EC2E54A1</TxRefNum> 
						<TxRefIdx>1</TxRefIdx> 
						<ProcStatus>0</ProcStatus> => "Successful"
						<ApprovalStatus>1</ApprovalStatus> => "Approved"
						<RespCode>00</RespCode> => "Approved"
						<AVSRespCode>H </AVSRespCode> => "Zip Match/Locale match"
						<CVV2RespCode> </CVV2RespCode> => "Not applicable (non-Visa)"
						<AuthCode>191044</AuthCode> 
						<RecurringAdviceCd/> 
						<CAVVRespCode/> 
						<StatusMsg>Approved</StatusMsg> 
						<RespMsg/> 
						<HostRespCode>00</HostRespCode> 
						<HostAVSRespCode>Y</HostAVSRespCode> 
						<HostCVV2RespCode/> 
						<CustomerRefNum/> 
						<CustomerName/> 
						<ProfileProcStatus/> 
						<CustomerProfileMessage/> 
						<RespTime>102708</RespTime>
					</NewOrderResp> 
				</Response>

				--------------------------------------------------
				New Order with AVS and Partial Authorization:

				<?xml version="1.0" encoding="UTF-8" ?> 
				<Response>
					<NewOrderResp> 
						<IndustryType /> 
						<MessageType>A</MessageType> 
						<MerchantID>700000123456</MerchantID> 
						<TerminalID>001</TerminalID> 
						<CardBrand>VI</CardBrand> 
						<AccountNum>4XXXXXXXXXXX1111</AccountNum> 
						<OrderID>844901</OrderID> 
						<TxRefNum>4C04887CE799F0BA541FDC447426A7B0F48E27A5</TxRefNum> 
						<TxRefIdx>0</TxRefIdx> => "Indicates the request did not ask to capture"
						<ProcStatus>0</ProcStatus> => "Indicates the request did not ask to capture"
						<ApprovalStatus>1</ApprovalStatus> => "Indicates an overall Issuer Approval"
						<RespCode>00</RespCode> => "The Auth Response Code stored by Gateway"
						<AVSRespCode>H</AVSRespCode> => "The AVS Response Code stored by Gateway"
						<CVV2RespCode /> => "Indicates CVV validation was not performed"
						<AuthCode>091141</AuthCode> 
						<RecurringAdviceCd /> 
						<CAVVRespCode /> 
						<StatusMsg>Approved</StatusMsg> 
						<RespMsg /> 
						<HostRespCode>00</HostRespCode> => "The Auth Response Code stored by Host"
						<HostAVSRespCode>Y</HostAVSRespCode> => "The AVS Response Code stored by Host"
						<HostCVV2RespCode /> 
						<CustomerRefNum /> 
						<CustomerName /> 
						<ProfileProcStatus /> => "Indicates a profile action was not requested"
						<CustomerProfileMessage /> 
						<RespTime>001140</RespTime> 
						<PartialAuthOccurred>Y</PartialAuthOccurred> => "Indicates the issuer returned a partial approval"
						<RequestedAmount>10000</RequestedAmount>
						<RedeemedAmount>7000</RedeemedAmount> => "The amount which was approved"
						<RemainingBalance></RemainingBalance> 
						<CountryFraudFilterStatus></CountryFraudFilterStatus> 
						<IsoCountryCode></IsoCountryCode>
					</NewOrderResp> 
				</Response>

				--------------------------------------------------
				
				New Order with AVS and CVV:

				<?xml version="1.0" encoding="UTF-8" ?> 
				<Response>
					<NewOrderResp> 
						<IndustryType />
						<MessageType>AC</MessageType> 
						<MerchantID>123456</MerchantID> 
						<TerminalID>001</TerminalID> 
						<CardBrand>VI</CardBrand> 
						<AccountNum>4XXXXXXX8881</AccountNum> 
						<OrderID>00000002</OrderID> 
						<TxRefNum>4C04885DDC2478DBE8A8C2731844EF1F90515309</TxRefNum> 
						<TxRefIdx>1</TxRefIdx> => "Indicates this response is for the first Capture"
						<ProcStatus>0</ProcStatus> => "Indicates Gateway Success for the transaction"
						<ApprovalStatus>0</ApprovalStatus> => "Indicates a decline by the Issuer"
						<RespCode>05</RespCode>  => "Indicates the decline code stored by Gateway"
						<AVSRespCode>F</AVSRespCode> => "Indicates the AVS code stored by Gateway"
						<CVV2RespCode>M</CVV2RespCode>  => "Indicates the CVV code stored by Gateway"
						<AuthCode></AuthCode>  => "A NULL AuthCode also indicates a decline or error"
						<RecurringAdviceCd /> 
						<CAVVRespCode /> 
						<StatusMsg>Approved</StatusMsg> 
						<RespMsg /> 
						<HostRespCode>530</HostRespCode>  => "Indicates the decline code stored by Host"
						<HostAVSRespCode>A</HostAVSRespCode>  => "This is the host AVS code"
						<HostCVV2RespCode>M</HostCVV2RespCode>  => "This is the host CVV code"
						<CustomerRefNum>TestProfile4</CustomerRefNum> 
						<CustomerName /> 
						<ProfileProcStatus>0</ProfileProcStatus>  => "Indicates a profile action succeeded separately of the transaction itself"
						<CustomerProfileMessage>Profile was created successfully</CustomerProfileMessage> 
						<RespTime>001109</RespTime> 
						<RequestedAmount></RequestedAmount> 
						<RedeemedAmount></RedeemedAmount>
						<RemainingBalance></RemainingBalance> 
						<CountryFraudFilterStatus></CountryFraudFilterStatus> 
						<IsoCountryCode></IsoCountryCode>
					</NewOrderResp> 
				</Response>

				--------------------------------------------------
				ProcStatus Error 1:

				<?xml version="1.0" encoding="UTF-8" ?> 
				<Response>
					<QuickResp> => "Indicates an initial Gateway generated error"
						<ProcStatus>9717</ProcStatus> => "The specific Gateway Error Code"
						<StatusMsg>Security Information - agent/chain/merchant is missing </StatusMsg> => "Response Text: A security error was detected"
					</QuickResp> 
				</Response>
				
				--------------------------------------------------
				ProcStatus Error 2:

				<?xml version="1.0" encoding="UTF-8" ?> 
				<Response>
					<QuickResp> => "Indicates an initial Gateway generated error"
						<TxRefNum>4C05310F121D8809E59DD07BB2D3938B642753B2</TxRefNum> 
						<TxRefIdx>0</TxRefIdx> 
						<ProcStatus>882</ProcStatus> => "The specific Gateway Error Code"
						<StatusMsg>This transaction is locked down. You cannot mark or unmark it.</StatusMsg> => "Response Text: This transaction reference has expired or has already
been marked for capture"
						<ApprovalStatus>2</ApprovalStatus> 
					</QuickResp>
				</Response>

				--------------------------------------------------
		//--->

		<cfscript>
			var local = {};
			var results = "";
			var transactionResult = "";
			var arrayParameters = [];
			var i = "";
			
			local.p = arguments.payload.trim();
			local.h["Content-Type"] = "text/xml";
			local.h["Content-Length"] = len(local.p);
			
			local.processorData = createResponse(argumentCollection = super.process(payload = local.p, headers=local.h));
			
			if ( !ocal.processorData.hasError() ) 
			{
				if ( len(local.processorData.getResult()) && isXML(local.processorData.getResult()) ) 
				{
					
					results = xmlParse(local.processorData.getResult());
					local.processorData.setParsedResult(results);
					
					try 
					{
						transactionResult = XmlSearch(results,"//XMLTrans"); /* this is the main info node in the returned XML payload */

						if ( isarray(transactionResult) && arraylen(transactionResult) ) 
						{
							if ( structkeyexists(transactionResult[1], "XMLChildren") && ( isarray(transactionResult[1].XMLChildren) && arraylen(transactionResult[1].XMLChildren) ) )
							{
								arrayParameters = transactionResult[1].XMLChildren;
								
								for ( i = 1; i <= arraylen(arrayParameters); i++ )
								{
									if ( arrayParameters[i].XmlName == "status" && structkeyexists(variables.ProPayStatusCodes,arrayParameters[i].XmlText) )
									{	
										local.processorData.setMessage(variables.ProPayStatusCodes[arrayParameters[i].XmlText]);
									}

									if ( arrayParameters[i].XmlName == "ResponseCode" && structkeyexists(variables.ProPayResponseCodes,arrayParameters[i].XmlText) )
									{
										local.processorData.setMessage(variables.ProPayResponseCodes[arrayParameters[i].XmlText]);
									}

									if ( arrayParameters[i].XmlName == "transNum" )
									{
										local.processorData.setTransactionID(arrayParameters[i].XmlText);
									}

									if ( arrayParameters[i].XmlName == "AVS" )
									{
										local.processorData.setAVSCode(arrayParameters[i].XmlText);
									}

									if ( arrayParameters[i].XmlName == "status" )
									{
										switch (arrayParameters[i].XmlText) 
										{
											case "00": 
											{
												local.processorData.setStatus(getService().getStatusSuccessful());
												break;
											}
											case "58": 
											{
												local.processorData.setStatus(getService().getStatusDeclined());
												break;
											}
											case "48": 
											{
												local.processorData.setStatus(getService().getStatusDeclined());
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
							}
							else
							{
								local.processorData.setStatus(getService().getStatusUnknown());
								local.processorData.setMessage("There were no children for the XMLTrans node. [#arraylen(transactionResult)#]");
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

				<cfif len(arguments.account.getYear()) eq 4>
					<cfset arguments.account.setYear(right(arguments.account.getYear(),2)) />
				</cfif>

				<cfoutput>
					<cfxml variable="xmlRequest">
						<?xml version='1.0'?> 
						<!DOCTYPE Request.dtd> 
						<XMLRequest> 
							<certStr>#getPassword()#</certStr> 
							<class>partner</class>
							<XMLTrans> 
								<transType>04</transType> 
								<amount>#arguments.money.getCents()#</amount> 
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
								<amount>#arguments.money.getCents()#</amount> 
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

		<!---// transType for this is always 05 //--->

		<cfif structkeyexists(arguments.options, "invoiceNumber")>
			<cfset invoiceNumber = arguments.options["invoiceNumber"] />
		</cfif>

		<cfif len(arguments.account.getYear()) eq 4>
			<cfset arguments.account.setYear(right(arguments.account.getYear(),2)) />
		</cfif>

		<cfoutput>
			<cfxml variable="xmlRequest">
				<?xml version='1.0'?> 
				<!DOCTYPE Request.dtd> 
				<XMLRequest> 
					<certStr>#getPassword()#</certStr> 
					<class>partner</class>
					<XMLTrans> 
						<transType>05</transType> 
						<amount>#arguments.money.getCents()#</amount> 
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
						<transType>06</transType> 
						<accountNum>#getUsername()#</accountNum> 
						<transNum>#xmlformat(arguments.authorization)#</transNum>
						<invNum>#invoiceNumber#</invNum>
					</XMLTrans>
				</XMLRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="void" output="false" access="public" returntype="any" hint="Void Credit Card Authorization">
		<cfargument name="money" type="any" required="true" />
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
						<amount>#arguments.money.getCents()#</amount> 
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
						<amount>#arguments.money.getCents()#</amount> 
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
						<transType>34</transType> 
						<accountNum>#getUsername()#</accountNum>
						<cfif structkeyexists(arguments.options, "cardholder")>
							<payerName>#arguments.options["cardHolder"]#</payerName>
						<cfelse>
							<transNum>#xmlformat(arguments.transactionid)#</transNum>
						</cfif>
						<invNum>#invoiceNumber#</invNum>
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
	$Id: paymentech.cfc 000 2013-09-04 02:24:23Z jasonb $
	
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

	//--->
	
</cfcomponent>