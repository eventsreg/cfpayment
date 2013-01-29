<cfcomponent name="ProPay" extends="mxunit.framework.TestCase" output="false">

<!---
		Test suite for ProPay gateway

		Notes:

		$1.00 Minimum on credit card transactions
--->
	<cffunction name="setUp" returntype="void" access="public">	

		<cfset var gw = {} />

		<cfscript>  
			gw.path = "ProPay.ProPay";
			gw.Username = '30831756';
			gw.Password = '22e62fca4fc44b1a65863ca62a3668';
			gw.Partner = '';
			gw.Vendor = '';
			gw.TestMode = true;

			// create gw and get reference			
			variables.svc = createObject("component", "cfpayment.api.core").init(gw);
			variables.gw = variables.svc.getGateway();
		</cfscript>
	</cffunction>
	
	<cffunction name="testPurchase" access="public" returntype="void" output="false">
		<cfset var money = variables.svc.createMoney(100) /><!--- in cents, $1.00 --->
		<cfset var response = "" />
		<cfset var options = {} />
		
		<cfset options["email"] = "jason@example.com" />
		<cfset options["cardType"] = "visa" />
		<cfset options["comments"] = "This purchase was made for Some Event." />
		<cfset options["description"] = "Registration for Some Event" />
		
		<!---// gateway should allow valid card number //--->
		<cfset response = gw.purchase(money = money, account = createValidCard(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "The purchase did not succeed.") />
		
		<!---// gateway should reject invalid card number //--->
		<cfset response = gw.purchase(money = money, account = createInvalidCard(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertFalse(response.getSuccess(), "The purchase did succeed, but we expected the bad card number to fail.") />
		
		<!---// gateway should allow valid check, if signed up for it. //--->
		<cfset response = gw.purchase(money = money, account = createValidCheck(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertFalse(response.getSuccess(), "The check purchase was accepted, but that tender type is not allowed for this account.") />
	</cffunction>
	
	<cffunction name="testAuthorize" access="public" returntype="void" output="false">
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var options = {} />
		
		<cfset options["email"] = "jason@example.com" />
		<cfset options["cardType"] = "visa" />
		<cfset options["comments"] = "This authorization was made for Some Event." />
		<cfset options["description"] = "Registration for Some Event" />
		
		<!---// test the authorize method(s) //--->
		<cfset response = gw.authorize(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The authorization did not succeed.") />
		
		<!---// gateway should reject invalid card number //--->
		<cfset response = gw.authorize(money = money, account = createInvalidCard(), options = options) />
		<cfset debug(response.getParsedResult()) />
		<cfset assertFalse(response.getSuccess(), "The authorization did succeed, but we expected the bad card number to fail.") />
	</cffunction> 
	
	<cffunction name="testCapture" access="public" returntype="void" output="false">
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var options = {} />
		<cfset var transactionId = "" />
		
		<cfset options["email"] = "jason@example.com" />
		<cfset options["cardType"] = "visa" />
		<cfset options["comments"] = "This authorization was made for Some Event." />
		<cfset options["description"] = "Registration for Some Event" />
		
		<cfset response = gw.authorize(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The authorization before the capture did not succeed.") />
		
		<cfset response = gw.capture(money = money, authorization = response.getTransactionId(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "The capture did not succeed.") />
	</cffunction> 
	
	<cffunction name="testVoid" access="public" returntype="void" output="false">
		<cfset var money = variables.svc.createMoney(5000) /><!--- in cents, $50.00 --->
		<cfset var response = "" />
		<cfset var options = {} />
		<cfset var transactionId = "Vxxxx" />
		
		<cfset options["email"] = "jason@example.com" />
		<cfset options["cardType"] = "visa" />
		<cfset options["comments"] = "This authorization was made for Some Event." />
		<cfset options["description"] = "Registration for Some Event" />
		
		<!---// voiding an auth-only transaction //--->
		<cfset response = gw.authorize(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The authorization before the void did not succeed.") />
		
		<cfset response = gw.void(id = response.getTransactionID(), options = options) />
		<cfset assertTrue(response.getSuccess(), "You cannot void this Authorization transaction.") />
		
		<!---// voiding a sale transaction //--->
		<cfset response = gw.purchase(money = money, account = createValidCard(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "The purchase before the void did not succeed.") />
		
		<cfset response = gw.void(id = response.getTransactionID(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "You cannot void this Sale transaction.") />
		
		<!---// void a non-existent transaction //--->
		<cfset response.setTransactionID("VZZZZZZZZZZZZ") />
		<cfset response = gw.void(id = response.getTransactionID(), options = options) />
		<cfset assertFalse(response.getSuccess(), "The void was approved, but it should not exist and return an approval code of 2.") />
	</cffunction> 
	
	<cffunction name="testStatus" access="public" returntype="void" output="false">
		<cfset var money = variables.svc.createMoney(1000) /><!--- in cents, $10.00 --->
		<cfset var response = "" />
		<cfset var options = {} />
		<cfset var transactionId = "" />
		
		<cfset options["email"] = "jason@example.com" />
		<cfset options["cardType"] = "visa" />
		<cfset options["comments"] = "This authorization was made for Some Event." />
		<cfset options["description"] = "Registration for Some Event" />
		
		<!---// getting status for an auth-only transaction //--->
		<cfset response = gw.authorize(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The authorization before the status did not succeed.") />
		
		<cfset response = gw.status(transactionid = response.getTransactionID(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "You cannot get the status for this Authorization transaction.") />
		
		<!---// getting status for a sale transaction //--->
		<cfset response = gw.purchase(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The purchase before the status did not succeed.") />
		
		<cfset response = gw.status(transactionid = response.getTransactionID(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "You cannot get the status for this Sale transaction.") />
		
		<!---// getting status for a non-existent transaction //--->
		<cfset response.setTransactionID("VZZZZZZZZZZZZ") />
		<cfset response = gw.status(transactionid = response.getTransactionID(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertFalse(response.getSuccess(), "The status for the transaction was fetched, but it should not exist.") />
	</cffunction>
	
	<cffunction name="testReferencedCredit" access="public" returntype="void" output="false">
		<cfset var money = variables.svc.createMoney(1000) /><!--- in cents, $10.00 --->
		<cfset var response = "" />
		<cfset var options = {} />
		<cfset var transactionId = "" />
		
		<cfset options["email"] = "jason@example.com" />
		<cfset options["cardType"] = "visa" />
		<cfset options["comments"] = "This authorization was made for Some Event." />
		<cfset options["description"] = "Registration for Some Event" />
		
		<!---// crediting a valid sale transaction //--->
		<cfset response = gw.purchase(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The sale transaction before the credit did not succeed.") />
		
		<cfset response = gw.credit(money = money, transactionid = response.getTransactionID(), options = options) />
		<cfset debug(response.getMemento()) />
		<cfset assertTrue(response.getSuccess(), "You should be able to credit this sale transaction, but this one didn't work.") />
		
		<!---// getting status for a valid auth-only transaction: should fail, because these aren't allowed //--->
		<cfset response = gw.authorize(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The Authorization only transaction before the credit did not succeed.") />
		
		<cfset response = gw.credit(money = money, transactionid = response.getTransactionID(), options = options) />
		<cfset assertFalse(response.getSuccess(), "You cannot credit an Authorization transaction, but this one apparently worked.") />
		
		<!---// crediting a valid sale transaction, but only < the original amount //--->
		<cfset response = gw.purchase(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The sale transaction before the credit did not succeed.") />
		
		<cfset money.setCents(500) />
		
		<cfset response = gw.credit(money = money, transactionid = response.getTransactionID(), options = options) />
		<cfset assertTrue(response.getSuccess(), "You should be able to credit this sale transaction for a partial (less than) amount, but this one didn't work.") />
		
		<!---// crediting a valid sale transaction, but trying an amount > the original amount //--->
		<cfset response = gw.purchase(money = money, account = createValidCard(), options = options) />
		<cfset assertTrue(response.getSuccess(), "The sale transaction before the credit did not succeed.") />
		
		<cfset money.setCents(1001) />
		
		<cfset response = gw.credit(money = money, transactionid = response.getTransactionID(), options = options) />
		<cfset assertFalse(response.getSuccess(), "You should not be able to credit this sale transaction for a partial (greater than) amount, but this one worked.") />
	</cffunction>
	
	<!---// Private helper methods //--->
		
	<cffunction name="createValidCard" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4111111111111111) />
		<cfset account.setMonth(12) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(999) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("888") />
		<cfset account.setPostalCode("11111") />
		<cfset account.setCountry("USA") />
		<cfset account.setRegion("CA") />
		<cfset account.setCity("San Jose") />

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
		<cfset account.setAddress("236 N. Santa Cruz") />
		<cfset account.setPostalCode("95030") />
		<cfset account.setCountry("USA") />
		<cfset account.setRegion("CA") />
		<cfset account.setCity("San Jose") />

		<cfreturn account />	
	</cffunction>
	
	<cffunction name="createCardForErrorResponse" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4222222222222) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(999) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("888") />
		<cfset account.setPostalCode("77777") />
		<cfset account.setCountry("USA") />
		<cfset account.setRegion("CA") />
		<cfset account.setCity("San Jose") />

		<cfreturn account />	
	</cffunction>

	<cffunction name="createValidCardWithoutCVV" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4111111111111111) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue() />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("888") />
		<cfset account.setPostalCode("77777") />
		<cfset account.setCountry("USA") />
		<cfset account.setRegion("CA") />
		<cfset account.setCity("San Jose") />

		<cfreturn account />	
	</cffunction>

	<cffunction name="createValidCardWithBadCVV" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4111111111111111) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue(1111) />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("888") />
		<cfset account.setPostalCode("77777") />
		<cfset account.setCountry("USA") />
		<cfset account.setRegion("CA") />
		<cfset account.setCity("San Jose") />

		<cfreturn account />	
	</cffunction>
	
	<cffunction name="createValidCardWithoutStreetMatch" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4111111111111111) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue() />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("N. Santa Cruz") />
		<cfset account.setPostalCode("77777") />
		<cfset account.setCountry("USA") />
		<cfset account.setRegion("CA") />
		<cfset account.setCity("San Jose") />

		<cfreturn account />	
	</cffunction>

	<cffunction name="createValidCardWithoutZipMatch" access="private" returntype="any" output="false">
		<!--- these values simulate a valid card with matching avs/cvv --->
		<cfset var account = variables.svc.createCreditCard() />
		<cfset account.setAccount(4111111111111111) />
		<cfset account.setMonth(10) />
		<cfset account.setYear(year(now())+1) />
		<cfset account.setVerificationValue() />
		<cfset account.setFirstName("John") />
		<cfset account.setLastName("Doe") />
		<cfset account.setAddress("888") />
		<cfset account.setPostalCode("00000") />
		<cfset account.setCountry("USA") />
		<cfset account.setRegion("CA") />
		<cfset account.setCity("San Jose") />

		<cfreturn account />	
	</cffunction>
	
	<cffunction name="createValidCheck" access="private" returntype="any" output="false">
		<!--- these values simulate a valid check with necessary fields --->
		<cfset var account = variables.svc.createEFT() />
		<cfset account.setAccount("123123123") />
		<cfset account.setRoutingNumber("MZ123123123") />
		<cfset account.setAccountType("P") />

		<cfreturn account />	
	</cffunction>
	
</cfcomponent>
