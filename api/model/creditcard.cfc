<!---
	$Id: creditcard.cfc 152 2011-01-18 00:23:34Z briang $

	Copyright 2007 Brian Ghidinelli (http://www.ghidinelli.com/)

	Licensed under the Apache License, Version 2.0 (the "License"); you
	may not use this file except in compliance with the License. You may
	obtain a copy of the License at:

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--->
<cfcomponent name="creditcard" output="false" hint="Object for holding credit card data">
	<cfproperty name="firstName" type="string" default="" />
	<cfproperty name="lastName" type="string" default="" />
	<cfproperty name="address" type="string" default="" />
	<cfproperty name="address2" type="string" default="" />
	<cfproperty name="city" type="string" default="" />
	<cfproperty name="region" type="string" default="" />
	<cfproperty name="postalCode" type="string" default="" />
	<cfproperty name="country" type="string" default="" />
	<cfproperty name="phoneNumber" type="string" default="" />
	<cfproperty name="expMonth" type="numeric" default="" />
	<cfproperty name="expYear" type="numeric" default="" />
	<cfproperty name="account" type="numeric" default="" />
	<cfproperty name="verificationValue" type="numeric" default="" />
	<cfproperty name="nameOnCard" type="string" default="" />
	<cfproperty name="countryCode" type="string" default="" />
	<cfproperty name="company" type="string" default="" />

	<cfset variables.instance = {
		firstName = "",
		lastName = "",
		address = "",
		address2 = "",
		city = "",
		region = "",
		postalCode = "",
		country = "",
		countryCode = "",
		phoneNumber = "",
		expMonth = "",
		expYear = "",
		account = "",
		verificationValue = "",
		nameOnCard = "",
		company = "",
		email = ""
	} />

	<!--- expose global variables --->
	<cfset this.CREDITCARD_MIN_EXP_YEAR = year(now()) />
	<cfset this.CREDITCARD_MAX_EXP_YEAR = year(now())+10 />
	<cfset this.CREDITCARD_EXP_MONTH_DISPLAY_LIST = "01 - JAN,02 - FEB,03 - MAR,04 - APR,05 - MAY,06 - JUN,07 - JUL,08 - AUG,09 - SEP,10 - OCT,11 - NOV,12 - DEC" />
	<cfset this.CREDITCARD_EXP_MONTH_VALUES_LIST = "1,2,3,4,5,6,7,8,9,10,11,12" />
	<cfset this.CREDITCARD_EXP_YEAR_LIST = "" /><!--- set during init() --->

	<!--- INITIALIZATION / CONFIGURATION --->
	<cffunction name="init" access="public" returntype="creditcard" output="false">
		<cfset var ctr = 0 />
		<cfset this.CREDITCARD_EXP_YEAR_LIST = "" />
		<cfloop from="#this.CREDITCARD_MIN_EXP_YEAR#" to="#this.CREDITCARD_MAX_EXP_YEAR#" index="ctr">
			<cfset this.CREDITCARD_EXP_YEAR_LIST = ListAppend(this.CREDITCARD_EXP_YEAR_LIST, ctr) />
		</cfloop>
		<cfreturn this />
 	</cffunction>

	<!---
		// CardTypes              Prefix          Width
		// American Express       34, 37            15
		// Diners Club            300 to 305, 36    14
		// Carte Blanche          38                14
		// Discover               6011              16
		// EnRoute                2014, 2149        15
		// JCB                    3                 16
		// JCB                    2131, 1800        15
		// Master Card            51 to 55          16
		// Visa                   4                 13, 16

		// Most comprehensive seems to be Wikipedia: http://en.wikipedia.org/wiki/Credit_card_number
	--->

	<!--- Various helper "is*" checks to assist merchants with selectively accepting card types
		  Checks BIN numbers and acceptable lengths Does not prevent processing: validate() with 
		  Luhn algorithm (mod10) and other checks does that.
	 --->
	<cffunction name="getIsAmex" access="public" returntype="any" output="false">
		<cfif (left(getAccount(), 2) EQ 34 OR left(getAccount(), 2) EQ 37) AND len(getAccount()) EQ 15>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="getIsDiscover" access="public" returntype="any" output="false">
		<cfif (left(getAccount(), 4) EQ 6011 OR left(getAccount(), 2) EQ 65) AND len(getAccount()) EQ 16>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="getIsMasterCard" access="public" returntype="any" output="false">
		<cfif (left(getAccount(), 2) GTE 51 AND left(getAccount(), 2) LTE 55) AND len(getAccount()) EQ 16>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="getIsVisa" access="public" returntype="any" output="false">
		<cfif left(getAccount(), 1) EQ 4 AND (len(getAccount()) EQ 13 OR len(getAccount()) EQ 16)>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<!--- Expiration date must not only be numeric but must be in the future (valid until the end of current month) --->
	<cffunction name="getIsExpirationValid" access="public" returntype="any" output="false">
		<cfif getExpirationDate() GTE now()>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<!--- convenience boolean wrapper around validate() --->
	<cffunction name="getIsValid" access="public" returntype="boolean" output="false" hint="True/false the credit card is valid">
		<cfreturn arrayLen(validate()) EQ 0 />
	</cffunction>

	<!--- if we pass this successfully, we should be able to send it to the gateway safely --->
	<cffunction name="validate" access="public" returntype="any" output="false" hint="Verify the account is valid">
		<cfargument name="requireAVS" type="boolean" default="true" />
		<cfargument name="requireVerificationValue" type="boolean" default="true" />

		<cfset var errors = [] />
		<cfset var thisError = {} />

		<!---// Name On Card is required, now //--->
		<cfif len(trim(getNameOnCard())) eq 0>
			<cfset thisError.field = "nameOnCard" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "The cardholder name is required" />
			<cfset arrayappend(errors, duplicate(thisError)) />
		</cfif>

		<!--- First Name --->
		<!--- <cfif (NOT len(trim(getFirstName())))>
			<cfset thisError.field = "firstName" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "First name is required" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif> --->

		<!--- Last Name --->
		<!--- <cfif NOT len(trim(getLastName()))>
			<cfset thisError.field = "lastName" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "Last name is required" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif> --->

		<cfif arguments.requireAVS>
			<!--- Address --->
			<cfif NOT len(trim(getAddress()))>
				<cfset thisError.field = "address" />
				<cfset thisError.type = "required" />
				<cfset thisError.message = "Street address is required" />
				<cfset arrayAppend(errors, duplicate(thisError)) />
			</cfif>

			<!--- Postal Code --->
			<cfif NOT len(trim(getPostalCode()))>
				<cfset thisError.field = "postalCode" />
				<cfset thisError.type = "required" />
				<cfset thisError.message = "Postal code is required" />
				<cfset arrayAppend(errors, duplicate(thisError)) />
			</cfif>
		</cfif>

		<!--- AVS really only cares about the numbers at the beginning of the address line so verify there is one --->
		<!--- NOTE: This check doesn't work with PO Box lines, e.g. "P. O. Box 1234" would return as an error --->
		<!--- <cfif len(getAddress()) AND NOT isNumeric(left(trim(getAddress()), 1))>
			<cfset thisError.field = "address" />
			<cfset thisError.type = "invalidValue" />
			<cfset thisError.message = "Address must contain the street number" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif> --->
		<!--- TODO: validate postal code length/format? For common countries like US/Canada? --->

		<!--- Verification Code --->
		<cfif arguments.requireVerificationValue>
			<cfif NOT len(getVerificationValue())>
				<cfset thisError.field = "verificationValue" />
				<cfset thisError.type = "required" />
				<cfset thisError.message = "Security code is required" />
				<cfset arrayAppend(errors, duplicate(thisError)) />
			</cfif>
		</cfif>

		<cfif len(getVerificationValue()) AND NOT isNumeric(getVerificationValue())>
			<cfset thisError.field = "verificationValue" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Security code is not numeric" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>
		
		<cfif len(getVerificationValue()) AND (len(getVerificationValue()) LT 3 OR len(getVerificationValue()) GT 4)>
			<cfset thisError.field = "verificationValue" />
			<cfset thisError.type = "invalidValue" />
			<!--- reflect the position of the CVV value --->
			<cfif getIsAmex()>
				<cfset thisError.message = "Security code must be four digits and is found on the front of the credit card" />
			<cfelse>
				<cfset thisError.message = "Security code must be three digits and is found on the back of the credit card near the signature strip" />
			</cfif>
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>

		<!--- Expiration Month --->
		<cfif not len(getMonth())>
			<cfset thisError.field = "month" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "Expiration month is required" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>
		<cfif len(getMonth()) AND NOT isNumeric(getMonth())>
			<cfset thisError.field = "month" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Expiration month is not numeric" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>
		<cfif len(getMonth()) AND NOT (getMonth() GTE 1 AND getMonth() LTE 12)>
			<cfset thisError.field = "month" />
			<cfset thisError.type = "invalidValue" />
			<cfset thisError.message = "Expiration month must be between 1 and 12" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>

		<!--- Expiration Year --->
		<cfif NOT len(getYear())>
			<cfset thisError.field = "Year" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "Expiration year is required" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>
		<cfif len(getYear()) AND NOT isNumeric(getYear())>
			<cfset thisError.field = "Year" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Expiration year is not numeric" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>
		<!--- expiration year must be later than today and less than 10 years in the future --->
		<cfif len(getYear()) AND NOT (getYear() GTE this.CREDITCARD_MIN_EXP_YEAR AND getYear() LTE this.CREDITCARD_MAX_EXP_YEAR)>
			<cfset thisError.field = "Year" />
			<cfset thisError.type = "invalidValue" />
			<cfset thisError.message = "Expiration year must be between #year(now())# and #year(now()) + 10#" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>

		<!--- Expiration date must be in the future--->
		<cfif NOT getIsExpirationValid()>
			<cfset thisError.field = "expiration" />
			<cfset thisError.type = "invalidValue" />
			<cfset thisError.message = "Expiration date must be in the future" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>

		<!--- Account Number (13-16 digits), only the digits are stored via setAccount() --->
		<cfif NOT len(getAccount())>
			<cfset thisError.field = "account" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "Account number is required" />
			<cfset arrayAppend(errors, duplicate(thisError)) />
		</cfif>
		<!--- allow special cases for testing: 1 and 2 --->
		<cfif not ListFind("1,2", getAccount())>
			<cfif len(getAccount()) AND (len(getAccount()) LT 13 OR len(getAccount()) GT 16)>
				<cfset thisError.field = "account" />
				<cfset thisError.type = "invalidValue" />
				<cfset thisError.message = "Account number must be between 13 and 16 digits" />
				<cfset arrayAppend(errors, duplicate(thisError)) />
			</cfif>
			<cfif len(getAccount()) AND NOT getIsMod10(getAccount())>
				<cfset thisError.field = "account" />
				<cfset thisError.type = "invalidValue" />
				<cfset thisError.message = "Account number is invalid - please check the number carefully" />
				<cfset arrayAppend(errors, duplicate(thisError)) />
			</cfif>
		</cfif>

		<cfreturn errors />
	</cffunction>

	<!---// ACCESSORS //--->
	<cffunction name="setNameOnCard" access="public" returntype="any" output="false"><cfset variables.instance.nameOnCard = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getNameOnCard" access="public" returntype="any" output="false"><cfreturn variables.instance.nameOnCard /></cffunction>

	<cffunction name="setFirstName" access="public" returntype="any" output="false"><cfset variables.instance.firstName = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getFirstName" access="public" returntype="any" output="false"><cfreturn variables.instance.firstName /></cffunction>

	<cffunction name="setLastName" access="public" returntype="any" output="false"><cfset variables.instance.lastName = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getLastName" access="public" returntype="any" output="false"><cfreturn variables.instance.lastName /></cffunction>
	
	<cffunction name="getName" access="public" returntype="any" hint="I return the firstname and last name as one string." output="false">
		<cfset var ret = getFirstName() />
		<cfif len(ret) and len(getLastName())>
			<cfset ret = ret & " " />
		</cfif>
		<cfset ret = ret & getLastName() />
		<cfreturn ret />
	</cffunction>

	<cffunction name="setAddress" access="public" returntype="any" output="false"><cfset variables.instance.address = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getAddress" access="public" returntype="any" output="false"><cfreturn variables.instance.address /></cffunction>

	<cffunction name="setAddress2" access="public" returntype="any" output="false"><cfset variables.instance.address2 = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getAddress2" access="public" returntype="any" output="false"><cfreturn variables.instance.address2 /></cffunction>

	<cffunction name="setCity" access="public" returntype="any" output="false"><cfset variables.instance.city = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getCity" access="public" returntype="any" output="false"><cfreturn variables.instance.city /></cffunction>

	<cffunction name="setRegion" access="public" returntype="any" hint="Region is synonym for State or Province" output="false"><cfset variables.instance.region = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getRegion" access="public" returntype="any" output="false"><cfreturn variables.instance.region /></cffunction>

	<cffunction name="setPostalCode" access="public" returntype="any" output="false"><cfset variables.instance.postalCode = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getPostalCode" access="public" returntype="any" output="false"><cfreturn variables.instance.postalCode /></cffunction>

	<cffunction name="setCountry" access="public" returntype="any" output="false"><cfset variables.instance.country = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getCountry" access="public" returntype="any" output="false"><cfreturn variables.instance.country /></cffunction>

	<cffunction name="setCountryCode" access="public" returntype="any" output="false"><cfset variables.instance.countryCode = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getCountryCode" access="public" returntype="any" output="false"><cfreturn variables.instance.countryCode /></cffunction>

	<cffunction name="setPhoneNumber" access="public" returntype="any" output="false"><cfset variables.instance.PhoneNumber = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getPhoneNumber" access="public" returntype="any" output="false"><cfreturn variables.instance.PhoneNumber /></cffunction>

	<cffunction name="setMonth" access="public" returntype="any" output="false"><cfset variables.instance.expMonth = numbersOnly(arguments[1]) /><cfreturn this /></cffunction>
	<cffunction name="getMonth" access="public" returntype="any" output="false"><cfreturn variables.instance.expMonth /></cffunction>

	<cffunction name="setYear" access="public" returntype="any" output="false"><cfset variables.instance.expYear = numbersOnly(arguments[1]) /><cfreturn this /></cffunction>
	<cffunction name="getYear" access="public" returntype="any" output="false"><cfreturn variables.instance.expYear /></cffunction>
	
	<cffunction name="getExpirationDate" access="public" returntype="date" output="false">
		<cftry>
			<cfreturn dateAdd('d', -1, dateAdd('m', 1, createDate(val(getYear()), val(getMonth()), 1))) />
			<cfcatch type="any">
				<!--- if we can't add the dates, the month/year are invalid, so send back an obviously invalid date --->
				<cfreturn createDate(1969, 1, 1) />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="setAccount" access="public" returntype="any" output="false"><cfset variables.instance.account = numbersOnly(arguments[1]) /><cfreturn this /></cffunction>
	<cffunction name="getAccount" access="public" returntype="any" output="false"><cfreturn variables.instance.account /></cffunction>
	
	<cffunction name="getAccountMasked" access="public" returntype="any" hint="Display the account number masked according to PCI DSS requirements" output="false">
		<cfset var num = getAccount() />
		<cfif len(num) EQ 16>
			<cfreturn "#left(num, 4)#-XXXX-XXXX-#right(num, 4)#" />
		<cfelse>
			<cfreturn left(num, 4) & "-" & repeatString("X", len(num) - 8) & "-" & right(num, 4) />
		</cfif>
	</cffunction>

	<cffunction name="setVerificationValue" access="public" returntype="any" output="false"><cfset variables.instance.verificationValue = numbersOnly(arguments[1]) /><cfreturn this /></cffunction>
	<cffunction name="getVerificationValue" access="public" returntype="any" output="false"><cfreturn variables.instance.verificationValue /></cffunction>

	<cffunction name="setCompany" access="public" returntype="any" output="false"><cfset variables.instance.company = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getCompany" access="public" returntype="any" output="false"><cfreturn variables.instance.company /></cffunction>

	<cffunction name="setEmail" access="public" returntype="any" output="false"><cfset variables.instance.email = arguments[1] /><cfreturn this /></cffunction>
	<cffunction name="getEmail" access="public" returntype="any" output="false"><cfreturn variables.instance.email /></cffunction>
	
	<!---// private workers for validation / etc //--->
	<cffunction name="numbersOnly" access="private" returntype="any" output="false"><cfreturn reReplace(arguments[1], "[^[:digit:]]", "", "ALL") /></cffunction>

	<cffunction name="getIsMod10" access="private" returntype="any" output="false">
		<cfscript>
		/**
		 * Checks to see whether a string passed to it passes the Luhn algorithm (also known as the Mod10 algorithm)
		 *
		 * @param card_number 	 String to check. (Required)
		 * @return Returns a boolean.
		 * @author Scott Glassbrook (scott@phydiux.com)
		 * @version 1, April 22, 2003
		 */
		var rebmun_drac = Reverse(ReReplaceNoCase(getAccount(),  "[^0-9]",  "",  "All"));
		var length = len(rebmun_drac);
		var even_list = "";
		var even_numbers = "0";
		var odd_numbers = "0";
		var loop1 = "1";
		var loop2 = "1";

		while (loop1 LTE length)
		{
			if ((loop1 mod 2) eq "0")
				even_list = even_list & (mid(rebmun_drac, loop1, 1) * 2);
			else
				odd_numbers  = (odd_numbers + mid(rebmun_drac, loop1, 1));
			 loop1 = loop1 + 1;
		}

		while (loop2 LTE len(even_list))
		{
			even_numbers = (even_numbers + mid(even_list, loop2, 1));
			loop2 = loop2 + 1;
		}

		if ((even_numbers + odd_numbers) mod 10 eq "0")
			return true;
		else
			return false;
		</cfscript>
	</cffunction>

	<!---// Usage: return a copy of the internal values //--->
	<cffunction name="getMemento" output="false" access="public" returntype="any" hint="return a copy of the internal values">
		<cfreturn duplicate(variables.instance) />
	</cffunction>
</cfcomponent>
