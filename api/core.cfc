<cfcomponent name="core" output="false" displayname="CFPAYMENT Core" hint="The core API for CFPAYMENT">
	<cfset variables.instance = {} />
	<cfset variables.instance.VERSION = "@VERSION@" />

	<cffunction name="init" output="false" access="public" returntype="any" hint="Initialize the core API and return a reference to it">
		<cfargument name="config" type="struct" required="true" />

		<cfset variables.instance.config = arguments.config />

		<!--- the core service expects a structure of configuration information to be passed to it telling it what gateway to use and so forth --->
		<cftry>
			<cfset variables.instance.gateway = createObject("component", "gateway.#lCase(variables.instance.config.path)#").init(config = variables.instance.config, service = this) />

			<cfcatch type="Any">
				<cfthrow message="Invalid Gateway Specified (gateway.#lCase(variables.instance.config.path)#). Reason: #serializejson(cfcatch)#" type="cfpayment.InvalidGateway" />
			</cfcatch>
		</cftry>

		<cfreturn this />
	</cffunction>


	<!--- PUBLIC METHODS --->
	<cffunction name="getGateway" access="public" output="false" returntype="any" hint="return the gateway or throw an error">
		<cfreturn variables.instance.gateway />
	</cffunction>

	<!--- getters and setters --->
	<cffunction name="getVersion" access="public" output="false" returntype="string">
		<cfif isNumeric(variables.instance.version)>
			<cfreturn variables.instance.version />
		<cfelse>
			<cfreturn "SVN" />
		</cfif>
	</cffunction>

	<cffunction name="createCreditCard" output="false" access="public" returntype="any" hint="return a credit card object for population">
		<cfreturn createObject("component", "model.creditcard").init(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="createEFT" output="false" access="public" returntype="any" hint="create an electronic funds transfer (EFT) object for population">
		<cfreturn createObject("component", "model.eft").init(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="createToken" output="false" access="public" returntype="any" hint="create a remote storage token for population">
		<cfreturn createObject("component", "model.token").init(argumentCollection = arguments) />
	</cffunction>

	<cffunction name="createMoney" output="false" access="public" returntype="any" hint="Create a money component for amount and currency conversion and formatting">
		<cfreturn createObject("component", "model.money").init(argumentCollection = arguments) />
	</cffunction>

	<!--- statuses to determine success and failure --->
	<cffunction name="getStatusUnprocessed" output="false" access="public" returntype="any" hint="This status is used to denote the transaction wasn't performed">
		<cfreturn -1 />
	</cffunction>
	<cffunction name="getStatusSuccessful" output="false" access="public" returntype="any" hint="This status indicates success">
		<cfreturn 0 />
	</cffunction>
	<cffunction name="getStatusPending" output="false" access="public" returntype="any" hint="This status indicates when we have sent a request to the gateway and are awaiting response (Transaction API)">
		<cfreturn 1 />
	</cffunction>
	<cffunction name="getStatusDeclined" output="false" access="public" returntype="any" hint="This status indicates a declined transaction">
		<cfreturn 2 />
	</cffunction>
	<cffunction name="getStatusFailure" output="false" access="public" returntype="any" hint="This status indicates something went wrong like the gateway threw an error but we believe the transaction was not processed">
		<cfreturn 3 />
	</cffunction>
	<cffunction name="getStatusTimeout" output="false" access="public" returntype="any" hint="This status indicates the remote server doesn't answer meaning we don't know if transaction was processed">
		<cfreturn 4 />
	</cffunction>
	<cffunction name="getStatusUnknown" output="false" access="public" returntype="any" hint="This status indicates an exception we don't know how to handle (yet)">
		<cfreturn 99 />
	</cffunction>
	<cffunction name="getStatusErrors" output="false" access="public" returntype="any" hint="This defines which statuses are errors">
		<cfreturn "3,4,99" />
	</cffunction>
</cfcomponent>