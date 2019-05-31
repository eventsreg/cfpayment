<cfscript>
    try {
        jstr = function (cfml_string) { return javaCast("java.lang.String", cfml_string) };

        env = createObject("java", "com.braintreegateway.Environment", "/jars/braintree-java-2.96.0.jar");
        gw = createObject("java", "com.braintreegateway.BraintreeGateway", "/jars/braintree-java-2.96.0.jar").init(
            env.Sandbox,
            jstr("9dcqy4pjq3v4m4tq"),
            jstr("jyqr36f7kx2qsmfx"),
            jstr("77dd270249a6fde850d933d84cd9424d")
        );

        acct = gw.merchantAccount().find(jstr("eventsregistrationllc"));
        
        if ( acct.getStatus().name() == "ACTIVE" ) {
            trans_request = createObject("java", "com.braintreegateway.TransactionRequest", "/jars/braintree-java-2.96.0.jar");

            credit_card_request = trans_request
                .amount(javacast("bigdecimal", 20.00))
                .orderId(jstr("TESTORDER-02"))
                .merchantAccountId(acct.getId())
                .customField("trackingnumber", "11112")
                .customField("event", "E-vents Registration Test Event")
                .customer()
                    .firstName(jstr("Drew"))
                    .lastName(jstr("Smith"))
                    .company(jstr("E-vents Registration"))
                    .phone(jstr("312-555-1234"))
                    .email(jstr("drew@example.com"))
                    .done()
                .creditCard()
                    .number(jstr("4111111111111111"))
                    .cvv(jstr("999"))
                    .expirationDate(jstr("09/23"))
                    .cardholderName(jstr("Drew S. Smith"))
                    .done()
                .billingAddress()
                    .firstName(jstr("Drew"))
                    .lastName(jstr("Smith"))
                    .company(jstr("E-vents Registration"))
                    .streetAddress(jstr("1 E Main St"))
                    .extendedAddress(jstr("Suite 403"))
                    .locality(jstr("Chicago"))
                    .region(jstr("IL"))
                    .postalCode(jstr("60622"))
                    .countryCodeAlpha2(jstr("US"))
                    .done()
                .options()
                    .submitForSettlement(true)
                    .done();

            result = gw.transaction().sale(credit_card_request);

            dump(result);
            dump(result.getTarget());

                dump(result.getTarget().getProcessorAuthorizationCode());
                dump(result.getTarget().getProcessorResponseCode());
                dump(result.getTarget().getProcessorResponseText());
                dump(result.getTarget().getProcessorResponseType());
                dump(result.getTarget().getProcessorSettlementResponseCode());
                dump(result.getTarget().getProcessorSettlementResponseText());
                dump(result.getTarget().getAdditionalProcessorResponse());
                dump(result.getTarget().getAuthorizedTransactionId());

            dump(result.getParameters());
            dump(result.getMessage());
            dump(result.getErrors());
            dump(result.getTransaction());
            dump(result.isSuccess());
            
        } else {
            echo("the sandbox account is not active");
        }
    } catch (Any e) {
        dump(e);
    }
</cfscript>
