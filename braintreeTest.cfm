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

        if ( gw.merchantAccount().find(jstr("eventsregistrationllc")).getStatus().name() == "ACTIVE" ) {
            trans_request = createObject("java", "com.braintreegateway.TransactionRequest", "/jars/braintree-java-2.96.0.jar");

            credit_card_request = trans_request
                .amount(javacast("bigdecimal", 10.00))
                .orderId(jstr("TESTORDER-01"))
                .merchantAccountId(jstr("9dcqy4pjq3v4m4tq"))
                .customField("trackingnumber", "11111")
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
                    .firstName("Drew")
                    .lastName("Smith")
                    .company("E-vents Registration")
                    .streetAddress("1 E Main St")
                    .extendedAddress("Suite 403")
                    .locality("Chicago")
                    .region("IL")
                    .postalCode("60622")
                    .countryCodeAlpha2("US")
                    .done()
                .options()
                    .submitForSettlement(true)
                    .done();

            result = gw.transaction().sale(credit_card_request);
            dump(result);

        } else {
            echo("the sandbox account is not active");
        }
    } catch (Any e) {
        dump(e);
    }
</cfscript>
