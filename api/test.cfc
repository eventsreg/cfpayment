<cfcomponent name="test" output="false" displayname="CFPAYMENT testing path" hint="The test">
	<cfset variables.instance = {} />
	<cfset variables.instance.VERSION = "@VERSION@" />

	<cffunction name="init" output="false" access="public" returntype="any" hint="Initialize the core API and return a reference to it">
		<cfargument name="config" type="struct" required="true" />

		<cfset variables.instance.config = arguments.config />

		<!--- the core service expects a structure of configuration information to be passed to it telling it what gateway to use and so forth --->
		<cftry>
			<!--- instantiate gateway and initialize it with the passed configuration --->

			<cfcatch>
				<cfthrow message="Invalid Gateway Specified: gateway.#lcase(variables.instance.config.path)#." type="cfpayment.InvalidGateway" />
			</cfcatch>
		</cftry>

		<cfreturn this />
	</cffunction>
</cfcomponent>