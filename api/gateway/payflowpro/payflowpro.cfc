<cfcomponent displayname="PayFlowPro Interface" extends="cfpayment.api.gateway.base" hint="PayFlowPro Gateway using XMLPay" output="false">
	<cfset variables.cfpayment.GATEWAY_NAME = "PayflowPro" />
	<cfset variables.cfpayment.GATEWAY_VERSION = "1.0" />
	<cfset variables.cfpayment.GATEWAY_LIVE_URL = "https://payflowpro.paypal.com/transaction" />
	<cfset variables.cfpayment.GATEWAY_TEST_URL = "https://pilot-payflowpro.paypal.com/transaction" />
	
	<cfset variables.payflowpro = {} />
	<cfset variables.payflowpro["0"] = "Transaction approved." />
	<cfset variables.payflowpro["1"] = "User authentication failed." />
	<cfset variables.payflowpro["2"] = "Invalid tender type. Your merchant bank account does not support the following credit card type that was submitted." />
	<cfset variables.payflowpro["3"] = "Invalid transaction type. Transaction type is not appropriate for this transaction." />
	<cfset variables.payflowpro["4"] = "Invalid amount format." />
	<cfset variables.payflowpro["5"] = "Invalid merchant information. Processor does not recognize your merchant account information." />
	<cfset variables.payflowpro["6"] = "Invalid or unsupported currency code." />
	<cfset variables.payflowpro["7"] = "Field format error." />
	<cfset variables.payflowpro["8"] = "Not a transaction server." />
	<cfset variables.payflowpro["9"] = "Too many parameters or invalid stream." />
	<cfset variables.payflowpro["10"] = "Too many line items." />
	<cfset variables.payflowpro["11"] = "Client time-out waiting for response." />
	<cfset variables.payflowpro["12"] = "Your card has been declined." />
	<cfset variables.payflowpro["13"] = "Referral. Transaction cannot be approved electronically but can be approved with a verbal authorization." />
	<cfset variables.payflowpro["19"] = "Original transaction ID not found." />
	<cfset variables.payflowpro["20"] = "Cannot find the customer reference number." />
	<cfset variables.payflowpro["22"] = "Invalid ABA number." />
	<cfset variables.payflowpro["23"] = "Invalid account number. Check credit card number and re-submit." />
	<cfset variables.payflowpro["24"] = "Invalid expiration date." />
	<cfset variables.payflowpro["25"] = "Invalid Host Mapping." />
	<cfset variables.payflowpro["26"] = "Invalid vendor account. Login information is incorrect." />
	<cfset variables.payflowpro["27"] = "Insufficient partner permissions." />
	<cfset variables.payflowpro["28"] = "Insufficient user permissions." />
	<cfset variables.payflowpro["29"] = "Invalid XML document. This could be caused by an unrecognized XML tag or a bad XML format that cannot be parsed by the system." />
	<cfset variables.payflowpro["30"] = "Duplicate transaction." />
	<cfset variables.payflowpro["31"] = "Error in adding the recurring profile." />
	<cfset variables.payflowpro["32"] = "Error in modifying the recurring profile." />
	<cfset variables.payflowpro["33"] = "Error in canceling the recurring profile." />
	<cfset variables.payflowpro["34"] = "Error in forcing the recurring profile." />
	<cfset variables.payflowpro["35"] = "Error in reactivating the recurring profile." />
	<cfset variables.payflowpro["36"] = "OLTP Transaction failed." />
	<cfset variables.payflowpro["37"] = "Invalid recurring profile ID." />
	<cfset variables.payflowpro["50"] = "Insufficient funds available in account." />
	<cfset variables.payflowpro["51"] = "Exceeds per transaction limit." />
	<cfset variables.payflowpro["99"] = "General error." />
	<cfset variables.payflowpro["100"] = "Transaction type not supported by host." />
	<cfset variables.payflowpro["101"] = "Time-out value too small." />
	<cfset variables.payflowpro["102"] = "Processor not available." />
	<cfset variables.payflowpro["103"] = "Error reading response from host." />
	<cfset variables.payflowpro["104"] = "Timeout waiting for processor response. Try your transaction again." />
	<cfset variables.payflowpro["105"] = "Credit error. Make sure you have not already credited this transaction, or that this transaction ID is for a creditable transaction. (For example, you cannot credit an authorization.)" />
	<cfset variables.payflowpro["106"] = "Host not available." />
	<cfset variables.payflowpro["107"] = "Duplicate suppression time-out." />
	<cfset variables.payflowpro["108"] = "Void error. Make sure the transaction ID entered has not already been voided." />
	<cfset variables.payflowpro["109"] = "Time-out waiting for host response." />
	<cfset variables.payflowpro["110"] = "Referenced auth (against order) Error." />
	<cfset variables.payflowpro["111"] = "Capture error. Either an attempt to capture a transaction that is not an authorization transaction type, or an attempt to capture an authorization transaction that has already been captured." />
	<cfset variables.payflowpro["112"] = "Failed AVS check. Address and ZIP code do not match." />
	<cfset variables.payflowpro["113"] = "Merchant sale total will exceed the sales cap with current transaction. ACH transactions only." />
	<cfset variables.payflowpro["114"] = "Card Security Code (CSC) Mismatch." />
	<cfset variables.payflowpro["115"] = "System busy, try again later." />
	<cfset variables.payflowpro["116"] = "VPS Internal error. Failed to lock terminal number." />
	<cfset variables.payflowpro["117"] = "Failed merchant rule check." />
	<cfset variables.payflowpro["118"] = "Invalid keywords found in string fields." />
	<cfset variables.payflowpro["120"] = "Attempt to reference a failed transaction." />
	<cfset variables.payflowpro["121"] = "Not enabled for feature." />
	<cfset variables.payflowpro["122"] = "Merchant sale total will exceed the credit cap with current transaction. ACH transactions only." />
	<cfset variables.payflowpro["125"] = "Fraud Protection Services Filter — Declined by filters." />
	<cfset variables.payflowpro["126"] = "Fraud Protection Services Filter — Flagged for review by filters. This is not an error, but a notice that the transaction is in a review status. The transaction has been authorized but requires you to review and to manually accept the transaction before it will be allowed to settle." />
	<cfset variables.payflowpro["127"] = "Fraud Protection Services Filter — Not processed by filters." />
	<cfset variables.payflowpro["128"] = "Fraud Protection Services Filter — Declined by merchant after being flagged for review by filters." />
	<cfset variables.payflowpro["132"] = "Card has not been submitted for update." />
	<cfset variables.payflowpro["133"] = "Data mismatch in HTTP retry request." />
	<cfset variables.payflowpro["150"] = "Issuing bank timed out." />
	<cfset variables.payflowpro["151"] = "Issuing bank unavailable." />
	<cfset variables.payflowpro["200"] = "Reauth error." />
	<cfset variables.payflowpro["201"] = "Order error." />
	<cfset variables.payflowpro["600"] = "Cybercash Batch Error." />
	<cfset variables.payflowpro["601"] = "Cybercash Query Error." />
	<cfset variables.payflowpro["1000"] = "Generic host error." />
	
	<cffunction name="process" output="false" access="private" returntype="any" hint="This is main conduit for the gateway.">
		<cfargument name="payload" type="string" required="true" />

		<cfscript>
			local = {};
			results = "";
			transactionResult = "";
			
			local.p = arguments.payload.trim();
			local.h["Content-Type"] = "text/xml";
			local.h["Content-Length"] = len(local.p);
			local.h["X-VPS-REQUEST-ID"] = createuuid();
			local.h["X-VPS-CLIENT-TIMEOUT"] = 45;
			local.h["X-VPS-VIT-INTEGRATION-PRODUCT"] = "Coldfusion/CFPayment";
			
			local.processorData = createResponse(argumentCollection = super.process(payload = local.p, headers=local.h));
			
			if ( not local.processorData.hasError() ) {
				if ( len(local.processorData.getResult()) and isXML(local.processorData.getResult()) ) {
					
					results = xmlParse(local.processorData.getResult());
					local.processorData.setParsedResult(results);
					
					try {
						transactionResult = XmlSearch(results,"//:TransactionResult");

						if ( isarray(transactionResult) and arraylen(transactionResult) eq 1 ) {

							if ( structkeyexists(transactionResult[1], "Result") and structkeyexists(variables.payflowpro,transactionResult[1].Result.xmlText) ) {
								local.processorData.setMessage(variables.payflowpro[transactionResult[1].Result.xmlText]);
							}else if ( structkeyexists(transactionResult[1], "Message") ) {
								local.processorData.setMessage(transactionResult[1].Message.xmlText);
							}else{
								local.processorData.setMessage("No message found.");
							}
							
							if ( structkeyexists(transactionResult[1], "PNRef") ) {
								local.processorData.setTransactionID(transactionResult[1].PNRef.xmlText);
							}
							
							if ( structkeyexists(transactionResult[1], "AuthCode") ) {
								local.processorData.setAuthorization(transactionResult[1].AuthCode.xmlText);
							}
							
							if ( structkeyexists(transactionResult[1],"AVSResult") ) {
								local.processorData.setAVSCode(transactionResult[1].AVSResult.xmlText);
							}
							
							if ( structkeyexists(transactionResult[1], "Result") ) {
								switch (transactionResult[1].Result.xmlText) {
									case "0": {
										local.processorData.setStatus(getService().getStatusSuccessful());
										break;
									}
									case "12": {
										local.processorData.setStatus(getService().getStatusDeclined());
										break;
									}
									case "23": {
										local.processorData.setStatus(getService().getStatusDeclined());
										break;
									}
									case "126": {
										local.processorData.setStatus(getService().getStatusSuccessful());
										break;
									}
									default: {
										local.processorData.setStatus(getService().getStatusFailure());
										break;
									}
								}
							}

						}else{
							local.processorData.setStatus(getService().getStatusUnknown());
							local.processorData.setMessage("Required Xml node missing from transaction response or there were too many of the necessary Xml node(s). [#arraylen(transactionResult)#]");
						}
					}
					catch(Any e) {
						local.processorData.setStatus(getService().getStatusUnknown());
						local.processorData.setMessage("Required Xml node missing from transaction response or an error was thrown (#e#)");
					}

				}else{
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
		
		<cfswitch expression="#lcase(listLast(getMetaData(arguments.account).fullname, "."))#">
			<cfcase value="creditcard">
				<cfoutput>
					<cfxml variable="xmlRequest">
						<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
							<RequestData>
								<Vendor>#getVendor()#</Vendor>
								<Partner>#getPartner()#</Partner>
								<Transactions>
									<Transaction>
										<Sale>
											<PayData>
												<Invoice>
													<BillTo>
														<Address>
															<Street>#xmlFormat(arguments.account.getAddress())#</Street>
															<City>#xmlformat(arguments.account.getCity())#</City>
															<State>#xmlformat(arguments.account.getRegion())#</State>
															<Zip>#xmlFormat(arguments.account.getPostalCode())#</Zip>
															<Country>#xmlformat(arguments.account.getCountry())#</Country>
														</Address>
														<cfif structkeyexists(arguments.options, "email") and isvalid("email",arguments.options["email"])><EMail>#xmlformat(arguments.options["email"])#</EMail></cfif>
													</BillTo>
													<TotalAmt>#arguments.money.getAmount()#</TotalAmt>
													<cfif structkeyexists(arguments.options,"description")><Description>#xmlformat(arguments.options["description"])#</Description></cfif>
													<cfif structkeyexists(arguments.options,"comments")><Comment>#xmlformat(arguments.options["comments"])#</Comment></cfif>
												</Invoice>
												<Tender>
													<Card>
														<CardType>#arguments.options["cardType"]#</CardType>
														<CardNum>#arguments.account.getAccount()#</CardNum>
														<ExpDate>#arguments.account.getYear()##arguments.account.getMonth()#</ExpDate>
														<CVNum>#xmlformat(arguments.account.getVerificationValue())#</CVNum>
														<NameOnCard>#xmlformat(arguments.account.getFirstName() & " " & arguments.account.getLastName())#</NameOnCard>
													</Card>
												</Tender>
											</PayData>
										</Sale>
									</Transaction>
								</Transactions>
							</RequestData>
							<RequestAuth>
								<UserPass>
									<User>#getUsername()#</User>
									<Password>#getPassword()#</Password>
								</UserPass>
							</RequestAuth>
						</XMLPayRequest>
					</cfxml>
				</cfoutput>
			</cfcase>
			<cfcase value="eft">
				<cfoutput>
					<cfxml variable="xmlRequest">
						<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
							<RequestData>
								<Vendor>#getVendor()#</Vendor>
								<Partner>#getPartner()#</Partner>
								<Transactions>
									<Transaction>
										<Sale>
											<PayData>
												<Invoice>
													<BillTo>
														<Address>
															<Street>#xmlFormat(arguments.account.getAddress())#</Street>
															<City>#xmlformat(arguments.account.getCity())#</City>
															<State>#xmlformat(arguments.account.getRegion())#</State>
															<Zip>#xmlFormat(arguments.account.getPostalCode())#</Zip>
															<Country>#xmlformat(arguments.account.getCountry())#</Country>
														</Address>
														<cfif structkeyexists(arguments.options, "email") and isvalid("email",arguments.options["email"])><EMail>#xmlformat(arguments.options["email"])#</EMail></cfif>
													</BillTo>
													<TotalAmt>#arguments.money.getAmount()#</TotalAmt>
													<cfif structkeyexists(arguments.options,"description")><Description>#xmlformat(arguments.options["description"])#</Description></cfif>
													<cfif structkeyexists(arguments.options,"comments")><Comment>#xmlformat(arguments.options["comments"])#</Comment></cfif>
												</Invoice>
												<Tender>
													<Check>
														<CheckType>#xmlformat(arguments.account.getAccountType())#</CheckType>
														<CheckNum>#xmlformat(arguments.account.getCheckNumber())#</CheckNum>
														<MICR>#xmlformat(arguments.account.getRoutingNumber())#</MICR>
													</Check>
												</Tender>
											</PayData>
										</Sale>
									</Transaction>
								</Transactions>
							</RequestData>
							<RequestAuth>
								<UserPass>
									<User>#getUsername()#</User>
									<Password>#getPassword()#</Password>
								</UserPass>
							</RequestAuth>
						</XMLPayRequest>
					</cfxml>
				</cfoutput>
			</cfcase>
			<cfdefaultcase>
				<cfthrow type="cfpayment.InvalidAccount" message="The account type #lcase(listLast(getMetaData(arguments.account).fullname, "."))# is not supported by this gateway." />
			</cfdefaultcase>
		</cfswitch>

		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="authorize" output="false" access="public" returntype="any" hint="Transaction: Authorization">
		<cfargument name="money" type="any" required="true" />
		<cfargument name="account" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />

		<cfoutput>
			<cfxml variable="xmlRequest">
				<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
					<RequestData>
						<Vendor>#getVendor()#</Vendor>
						<Partner>#getPartner()#</Partner>
						<Transactions>
							<Transaction>
								<Authorization>
									<PayData>
										<Invoice>
											<BillTo>
												<Address>
													<Street>#xmlFormat(arguments.account.getAddress())#</Street>
													<City>#xmlformat(arguments.account.getCity())#</City>
													<State>#xmlformat(arguments.account.getRegion())#</State>
													<Zip>#xmlFormat(arguments.account.getPostalCode())#</Zip>
													<Country>#xmlformat(arguments.account.getCountry())#</Country>
												</Address>
												<cfif structkeyexists(arguments.options, "email") and isvalid("email",arguments.options["email"])><EMail>#xmlformat(arguments.options["email"])#</EMail></cfif>
											</BillTo>
											<TotalAmt>#arguments.money.getAmount()#</TotalAmt>
											<cfif structkeyexists(arguments.options,"description")><Description>#xmlformat(arguments.options["description"])#</Description></cfif>
											<cfif structkeyexists(arguments.options,"comments")><Comment>#xmlformat(arguments.options["comments"])#</Comment></cfif>
										</Invoice>
										<Tender>
											<Card>
												<CardType>#arguments.options["cardType"]#</CardType>
												<CardNum>#arguments.account.getAccount()#</CardNum>
												<ExpDate>#arguments.account.getYear()##arguments.account.getMonth()#</ExpDate>
												<CVNum>#xmlformat(arguments.account.getVerificationValue())#</CVNum>
												<NameOnCard>#xmlformat(arguments.account.getFirstName() & " " & arguments.account.getLastName())#</NameOnCard>
											</Card>
										</Tender>
									</PayData>
								</Authorization>
							</Transaction>
						</Transactions>
					</RequestData>
					<RequestAuth>
						<UserPass>
							<User>#getUsername()#</User>
							<Password>#getPassword()#</Password>
						</UserPass>
					</RequestAuth>
				</XMLPayRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="capture" output="false" access="public" returntype="any" hint="Transaction: Capture">
		<cfargument name="money" type="any" required="true" />
		<cfargument name="authorization" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />

		<cfoutput>
			<cfxml variable="xmlRequest">
				<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
					<RequestData>
						<Vendor>#getVendor()#</Vendor>
						<Partner>#getPartner()#</Partner>
						<Transactions>
							<Transaction>
								<Capture>
									<PNRef>#xmlformat(arguments.authorization)#</PNRef>
								</Capture>
							</Transaction>
						</Transactions>
					</RequestData>
					<RequestAuth>
						<UserPass>
							<User>#getUsername()#</User>
							<Password>#getPassword()#</Password>
						</UserPass>
					</RequestAuth>
				</XMLPayRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="void" output="false" access="public" returntype="any" hint="Transaction: Void">
		<cfargument name="id" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />

		<cfoutput>
			<cfxml variable="xmlRequest">
				<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
					<RequestData>
						<Vendor>#getVendor()#</Vendor>
						<Partner>#getPartner()#</Partner>
						<Transactions>
							<Transaction>
								<Void>
									<PNRef>#xmlformat(arguments.id)#</PNRef>
								</Void>
							</Transaction>
						</Transactions>
					</RequestData>
					<RequestAuth>
						<UserPass>
							<User>#getUsername()#</User>
							<Password>#getPassword()#</Password>
						</UserPass>
					</RequestAuth>
				</XMLPayRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="status" output="false" access="public" returntype="any" hint="Transaction: Status">
		<cfargument name="transactionid" type="any" required="true" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />

		<cfoutput>
			<cfxml variable="xmlRequest">
				<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
					<RequestData>
						<Vendor>#getVendor()#</Vendor>
						<Partner>#getPartner()#</Partner>
						<Transactions>
							<Transaction>
								<GetStatus>
									<PNRef>#xmlformat(arguments.transactionid)#</PNRef>
								</GetStatus>
							</Transaction>
						</Transactions>
					</RequestData>
					<RequestAuth>
						<UserPass>
							<User>#getUsername()#</User>
							<Password>#getPassword()#</Password>
						</UserPass>
					</RequestAuth>
				</XMLPayRequest>
			</cfxml>
		</cfoutput>
		
		<cfreturn process(toString(xmlRequest)) />
	</cffunction>
	
	<cffunction name="credit" output="false" access="public" returntype="any" hint="Transaction: Credit">
		<cfargument name="money" type="any" required="true" />
		<cfargument name="transactionid" type="any" required="true" />
		<cfargument name="account" type="any" required="false" />
		<cfargument name="options" type="struct" required="false" default="#structNew()#" />

		<cfset var xmlRequest = "" />

		<cfoutput>
			<cfxml variable="xmlRequest">
				<XMLPayRequest Timeout='30' version = '2.0' xmlns='http://www.paypal.com/XMLPay'>
					<RequestData>
						<Vendor>#getVendor()#</Vendor>
						<Partner>#getPartner()#</Partner>
						<Transactions>
							<Transaction>
								<Credit>
								<cfif len(arguments.transactionid) gt 0>
									<!---// this is a Referenced Credit, but the amount might differ from original transaction amount //--->
									<PNRef>#xmlformat(arguments.transactionid)#</PNRef>
									<PayData>
										<Invoice>
											<TotalAmt>#arguments.money.getAmount()#</TotalAmt>
										</Invoice>
									</PayData>
								<cfelse>
									<!---// this is a Non-referenced Credit //--->
									<PayData>
										<Invoice>
											<TotalAmt>#arguments.money.getAmount()#</TotalAmt>
										</Invoice>
										<Tender>
											<Card>
												<CardType>#arguments.options["cardType"]#</CardType>
												<CardNum>#arguments.account.getAccount()#</CardNum>
												<ExpDate>#arguments.account.getYear()##arguments.account.getMonth()#</ExpDate>
											</Card>
										</Tender>
									</PayData>		
								</cfif>
								</Credit>
							</Transaction>
						</Transactions>
					</RequestData>
					<RequestAuth>
						<UserPass>
							<User>#getUsername()#</User>
							<Password>#getPassword()#</Password>
						</UserPass>
					</RequestAuth>
				</XMLPayRequest>
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
	$Id: payflowpro.cfc 000 2012-06-13 02:24:23Z jasonb $
	
	Copyright 2012 Jason Brookins (http://www.jasonbrookins.com/)
		
	Licensed under the Apache License, Version 2.0 (the "License"); you 
	may not use this file except in compliance with the License. You may 
	obtain a copy of the License at:
	 
		http://www.apache.org/licenses/LICENSE-2.0
		 
	Unless required by applicable law or agreed to in writing, software 
	distributed under the License is distributed on an "AS IS" BASIS, 
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
	See the License for the specific language governing permissions and 
	limitations under the License.
	
	Guide: https://cms.paypal.com/cms_content/US/en_US/files/developer/PP_PayflowPro_Guide.pdf
	XMLPay: https://cms.paypal.com/cms_content/US/en_US/files/developer/PP_PayflowPro_XMLPay_Guide.pdf

	//--->
	
</cfcomponent>