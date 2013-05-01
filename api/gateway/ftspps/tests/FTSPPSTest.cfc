<cfcomponent name="FTSPPSTest" extends="mxunit.framework.TestCase" output="false" hint="Basically the Braintree tests, but a couple additions">
	<!---
		Test transactions can be submitted with the following information:
		
		VISA 4012000033330026, 12115 LACKLAND, US, 63146, CVV 999.
 		MC 5424180279791732, 12115 LACKLAND, US, 63146, CVV 998.
 		
 		When you include the CVV, you should get back either "M" or "N".  When there is no CVV, we return "U"
	--->
	<cffunction name="setUp" returntype="void" access="public" output="false">	
		<cfscript>  
			var gw = {};
			
			variables.svc = createObject("component", "cfpayment.api.core");
			
			gw.path = "ftspps.ftspps";
			gw.MerchantAccount = "testing123"; // x_tran_key
			gw.Username = "003200031999"; // x_login
			gw.TestMode = true; // defaults to true

			// create gw and get reference			
			variables.svc.init(gw);
			variables.gw = variables.svc.getGateway();			
		</cfscript>
	</cffunction>

	<cffunction name="testPurchase" access="public" returntype="void" output="false">
	
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var options = {} />
		<cfset options.orderid = createuuid() /><!---Authorize.net requires a unique order id for each transaction.--->
		
		<!--- test the purchase method --->
		<cfset response = gw.purchase(money = money, account = createValidCard(), options = options) />
			<!---<cfset debug("Good CVV passed results in this code => " & response.getCVVCode()) />
			<cfset debug(response.getMemento()) />--->
		<cfset assertTrue(response.getSuccess(), "The purchase should have succeeded with createValidCard()") />
		<cfset assertTrue(response.isValidCVV(), "This was a good CVV but the response thinks it was bad") />

		<!--- this will be rejected by gateway because the card number is not valid --->
		<cfset response = gw.purchase(money = money, account = createInvalidCard(), options = options) />
		<cfset assertFalse(response.getSuccess(), "The purchase should have failed with createInvalidCard()") />
	
		<!--- When no CVV is passed, you should get a "U" response in getCVVCode() --->
		<cfset response = gw.purchase(money = variables.svc.createMoney(5010), account = createValidCardWithNoCVVSet(), options = options) />
			<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getCVVCode() eq "X", "No CVV was passed so the answer should have been ""X"" but was actually '#response.getCVVCode()#'") />
		
		<cfset response = gw.purchase(money = variables.svc.createMoney(5010), account = createValidCardWithoutCVV(), options = options) />
			<!---<cfset debug(response.getMemento()) />
			<cfset debug("No CVV sent: " & response.getCVVCOde() ) />--->
		<cfset assertTrue(response.getSuccess(), "The purchase was not a success even though no CVV was passed") />
		<cfset assertTrue(response.getCVVCode() eq "X", "No CVV was passed so the answer should have been ""X"" but was actually '#response.getCVVCode()#'") />

		<!---this should be rejected because of a bad CVV --->
		<cfset response = gw.purchase(money = variables.svc.createMoney(5020), account = createValidCardWithBadCVV(), options = options) />
			<cfset debug("Bad CVV passed results in this code => " & response.getCVVCode()) />
			<cfset debug(response.getMemento()) />
		<cfset assertFalse(response.getSuccess(), "The purchase showed as a success but used createValidCardWithBadCVV()") />
		<cfset assertTrue(response.getCVVCode() eq "U", "Bad CVV was passed so non-matching answer should be ""U"" but was actually '#response.getCVVCode()#'") />

		<cfset response = gw.purchase(money = variables.svc.createMoney(5030), account = createValidCardWithoutStreetMatch(), options = options) />
			<!---<cfset debug(response.getMemento()) />--->
		<cfset assertTrue(response.getSuccess(), "The purchase should have succeeded using createValidCardWithoutStreetMatch()") />
			<!---<cfset debug(response.getAVSMessage()) />--->
		<cfset assertTrue(response.isValidAVS(), "AVS Zip match only should be found") />
	
		<cfset response = gw.purchase(money = variables.svc.createMoney(5040), account = createValidCardWithoutZipMatch(), options = options) />
			<!---<cfset debug(response.getAVSMessage()) />
			<cfset debug(response.getMemento()) />--->
		<cfset assertTrue(response.getSuccess(), "The purchase should have succeeded using createValidCardWithoutZipMatch()") />
		<cfset assertTrue(response.isValidAVS(), "AVS Street match only should be found") />

		<!--- test specific response codes, requires enabling psuedo-test mode --->
		<cfset options["x_test_request"] = true />

		<!--- pass in 2.00 for a decline code --->
		<!---<cfset response = gw.purchase(money = variables.svc.createMoney(200), account = createCardForErrorResponse(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertFalse(response.getSuccess(), "The purchase should have failed using createCardForErrorResponse()") />--->

	</cffunction>

	<cffunction name="testAuthorizeOnly" access="public" returntype="void" output="false">
		<cfset var money = variables.svc.createMoney(5132) /><!--- in cents --->
		<cfset var response = "" />
		<cfset var options = {} />
		
		<cfset options.orderid = GenerateSecretKey("BLOWFISH") />
		
		<cfset response = gw.authorize(money = money, account = createValidCard(), options = options) />
		<!---<cfset debug(response.getMemento()) />--->
		<!---<cfset debug("Status=#response.getStatus()#, #response.getMessage()#") />
		<cfset debug("AVS1=#response.getAVSCode()#, #response.getAVSMessage()#") />--->
		<cfset assertTrue(response.getSuccess(), "The authorization failed but should have succeeded") />
		<cfset assertTrue(response.getAVSCode() EQ "M", "Street address + zip should match (Y)") />

		<!--- this will be rejected by gateway because the card number is not valid --->
		<cfset options.orderid = GenerateSecretKey("BLOWFISH") />
		<cfset response = gw.authorize(money = money, account = createInvalidCard(), options = options) />
		<cfset assertFalse(response.getSuccess(), "The authorization shouldn't have succeeded (2)") />

		<cfset options.orderid = GenerateSecretKey("BLOWFISH") />
		<cfset response = gw.authorize(money = money, account = createValidCardWithBadCVV(), options = options) />
		<cfset assertFalse(response.getSuccess(), "The authorization succeed, but should not have due to bad CVV 4") />
		<cfset assertTrue(response.getCVVCode() EQ "U", "Bad CVV was passed so non-matching answer should be provided (U) but was: '#response.getCVVCode()#'") />
	
		<!--- these additional AVS tests are apparently ignored by the payment processor --->
			
		<cfset options.orderid = GenerateSecretKey("BLOWFISH") />
		<cfset response = gw.authorize(money = money, account = createValidCardWithoutStreetMatch(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset debug(response.getSuccess()) />
		<cfset assertTrue(response.getSuccess(), "The authorization doesn't fail with no street match") />
		<cfset assertTrue(response.getAVSCode() EQ "M", "Expected 'M' AVSCode, but was given #response.getAVSCode()#'") />

		<cfset options.orderid = GenerateSecretKey("BLOWFISH") />
		<cfset response = gw.authorize(money = money, account = createValidCardWithoutZipMatch(), options = options) />
		<!---<cfset debug(response.getMemento()) />--->
		<!---<cfset debug("AVS3=#response.getAVSCode()#, #response.getAVSMessage()#") />--->
		<cfset assertTrue(response.getSuccess(), "The authorization should not have failed with no zip match") />
		<cfset assertTrue(response.getAVSCode() EQ "M", "Expected 'M' AVSCode, but was given #response.getAVSCode()#'") />

	</cffunction>

	<cffunction name="testAuthorizeThenCapture" access="public" returntype="void" output="false">
		<cfset var account = createValidCard() />
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var report = "" />
		<cfset var options = {} />
		<cfset var tid = "" />
		<cfset options.orderid = createuuid() />
		
		<cfset response = gw.authorize(money = money, account = account, options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "The authorization did not succeed") />

		<cfset response = gw.capture(money = money, authorization = response.getTransactionId(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "The capture did not succeed") />
	</cffunction>

	<cffunction name="testAuthorizeThenCredit" access="public" returntype="void" output="false">
	
		<cfset var account = createValidCard() />
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var report = "" />
		<cfset var options = {} />
		<cfset options.orderid = createuuid() />

		<cfset response = gw.authorize(money = money, account = account, options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "The authorization did not succeed") />

		<cfset response = gw.credit(transactionid = response.getTransactionID(), money = money, account = createValidCard(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertFalse(response.getSuccess(), "You cannot credit a preauth") />

	</cffunction>

	<cffunction name="testAuthorizeThenVoid" access="public" returntype="void" output="false">
	
		<cfset var account = createValidCard() />
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var report = "" />
		<cfset var options = {} />
		<cfset options.orderid = createuuid() />

		<cfset response = gw.authorize(money = money, account = account, options = options) />
			<!---<cfset debug(response.getMemento()) />--->
		<cfset assertTrue(response.getSuccess(), "The authorization did not succeed") />

		<cfset response = gw.void(transactionid = response.getTransactionID(), options = options) />
			<cfset debug(response.getMemento()) />
			<cfset debug(response.getAVSCode()) />
		<cfset assertTrue(response.getSuccess(), "You can void a preauth, but it failed") />

	</cffunction>
	
	<cffunction name="testPurchaseThenCredit" access="public" returntype="void" output="false">
	
		<cfset var account = createValidCard() />
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var report = "" />
		<cfset var options = {} />
		<cfset options.orderid = createuuid() />

		<cfset response = gw.purchase(money = money, account = account, options = options) />
			<!---<cfset debug(response.getMemento()) />--->
		<cfset assertTrue(response.getSuccess(), "The purchase did not succeed") />

		<cfset response = gw.credit(transactionid = response.getTransactionID(), money = money, account = account, options = options) />
			<!---<cfset debug(response.getTransactionID()) />
			<cfset debug(response.getMemento()) />--->
		<cfset assertTrue(response.getSuccess(), "SInce this was auth-capture transaction, it should have credited") />

		<cfset response = gw.credit(transactionid = response.getTransactionID(), money = variables.svc.createMoney(4500), account = account, options = options) />
			<cfset debug(response.getTransactionID()) />
			<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "You can partial credit a purchase") />

	</cffunction>
	
	<cffunction name="testPurchaseThenVoid" access="public" returntype="void" output="false">
	
		<cfset var account = createValidCard() />
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var report = "" />
		<cfset var options = {} />
		<cfset options.orderid = createuuid() />

		<cfset response = gw.purchase(money = money, account = account, options = options) />
		<cfset assertTrue(response.getSuccess(), "The purchase should have worked properly, but did not.") />

		<cfset response = gw.void(transactionid = response.getTransactionID(), options = options) />
			<cfset debug(response.getMemento()) />
		<cfset assertFalse(response.getSuccess(), "The void should not have worked, because this in an auth-capture. You would have to do a credit.") />

	</cffunction>	


	<!--- helper methods for creating test cards --->

	<cffunction name="createValidCard" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4012000033330026) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(999) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>
	
	<cffunction name="createCardForErrorResponse" access="private" returntype="any" output="false">
		<!--- these values simulate an invalid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4222222222222) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(999) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>

	<cffunction name="createInvalidCard" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4100000000000000) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(123) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>

	<cffunction name="createValidCardWithoutCVV" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv but no CVV --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4012000033330026) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue() />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>
	
	<cffunction name="createValidCardWithNoCVVSet" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv but no CVV --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4012000033330026) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>
	
	<cffunction name="createValidCardWithBadCVV" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv but a bad CVV --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4012000033330026) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(11) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>
	
	<cffunction name="createValidCardWithoutStreetMatch" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card but address doesn't match zip --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4012000033330026) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue() />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>

	<cffunction name="createValidCardWithoutZipMatch" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card but zip doesn't match address --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4012000033330026) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(999) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("00000") />
		<cfset account.setCountry("US") />

		<cfreturn account />	
	</cffunction>

	<cffunction name="createValidEFT" access="private" returntype="any" output="false">
		<!--- these values simulate a valid eft with matching avs/cvv --->
		<cfset var account = variables.svc.createEFT() />
		<cfset account.setAccount("123123123") />
		<cfset account.setRoutingNumber("123123123") />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("12115 LACKLAND") />
		<cfset account.setPostalCode("63146") />
		<cfset account.setPhoneNumber("415-555-1212") />
		<cfset account.setCountry("US") />
		
		<cfset account.setAccountType("checking") />

		<cfreturn account />	
	</cffunction>

</cfcomponent>
