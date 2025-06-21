// Task 1

// There are two config 1. Party Config 2. Super Config merge these two config and make a final config.

// - Change Order value for Final Config (priority party config).

// - Change Entity value for Final Config (priority party config).

// - Add Object in Super Config should be add in Final Config.

// - Remove Object in Super Config should be removed from Final Config


let partyConfig = [
  {
    "tab_name": "party_summary",
    "column_order": {
      "party_roles_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 1
      },
      "related_buying_company_text": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 3
      },
      "kam_name": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 2
      },
      "company_assigned_guarantor_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 4
      },
      "company_assigned_broker_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 5
      },
      "handling_company_name": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 6
      },
      "company_type": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 7
      },
      "grade_name": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 8
      },
      "business_type_name": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 9
      },
      "company_ref_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 10
      },
      "source": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 11
      },
      "company_credit_limit_type": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 12
      },
      "company_credit_limit": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 13
      },
      "company_permissible_overdue": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 14
      },
      "company_limit_used": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 15
      },
      "entry_date_string": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 16
      },
      "registration_date": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 17
      },
      "last_transaction_date": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 19
      },
      "first_business_date": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 18
      },
      "company_group": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 21
      },
      "status_name": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 22
      },
      "book_keeping_visibility": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 23
      },
      "kyc_status": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 24
      },
      "year_of_est": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 25
      },
      "don_brad_street_number": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 26
      },
      "turn_over": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 27
      },
      "member_of_trades": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 28
      },
      "offices": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 29
      },
      "presense_in_countries": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 30
      },
      "stores": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 31
      },
      "primary_phone": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 32
      },
      "primary_address_email": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 33
      },
      "primary_address_fax": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 34
      },
      "contact_person_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 35
      },
      "contact_admin": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 36
      },
      "contact_user": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 37
      },
      "owner_contact_person_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 38
      },
      "primary_contact_person_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 39
      },
      "primary_phone_with_code": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 40
      },
      "primary_contact_person_email": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 41
      },
      "primary_contact_fax_with_code": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 42
      },
      "secondary_contact_person_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 43
      },
      "other_contact": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 44
      },
      "kam_remark_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 45
      },
      "account_remark_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 46
      },
      "management_remark_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 47
      },
      "show_remark_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 48
      },
      "primary_address_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 49
      },
      "secondary_address_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 56
      },
      "other_address_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 59
      },
      "default_sale_types": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 52
      },
      "default_sale_terms": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 54
      },
      "permissible_sale_type": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 57
      },
      "permissible_sale_terms": {
        "entity_value": true,
        "is_active": true,
        "is_updatable": true,
        "order": 58
      },
      "guarntor_commision": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 60
      },
      "broker_commision": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 61
      },
      "premium_charge": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 62
      },
      "wvdDiscount": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 63
      },
      "termDiscount": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 64
      },
      "onlineDiscount": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 65
      },
      "eventDiscount": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 66
      },
      "shipping_company_details_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 67
      },
      "billing_company_details_text": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 68
      },
      "parcel_kam_name": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 3
      },
      "primary_address_city": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 50
      },
      "primary_address_state": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 51
      },
      "primary_country_name": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 53
      },
      "primary_address_zip_code": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 55
      },
      "latest_user_communication_date": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 20
      },
      "party_roles_text_party": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 1
      },
      "party_roles_text_party1": {
        "entity_value": false,
        "is_active": true,
        "is_updatable": true,
        "order": 1
      }
    }
   }
 ]

let superConfig = [
    {
      "tab_name": "party_summary",
      "column_order": {
        "party_roles_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 2
        },
        "related_buying_company_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 3
        },
        "kam_name": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 4
        },
        "company_assigned_guarantor_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 5
        },
        "company_assigned_broker_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 6
        },
        "handling_company_name": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 7
        },
        "company_type": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "grade_name": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "business_type_name": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "company_ref_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "source": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "company_credit_limit_type": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "company_credit_limit": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "company_permissible_overdue": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "company_limit_used": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 8
        },
        "entry_date_string": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 9
        },
        "registration_date": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 10
        },
        "last_transaction_date": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 14
        },
        "first_business_date": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 16
        },
        "company_group": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 17
        },
        "status_name": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 18
        },
        "book_keeping_visibility": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 18
        },
        "kyc_status": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 19
        },
        "year_of_est": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 20
        },
        "don_brad_street_number": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 21
        },
        "turn_over": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 22
        },
        "member_of_trades": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 23
        },
        "offices": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 24
        },
        "presense_in_countries": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 25
        },
        "stores": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 26
        },
        "primary_phone": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 27
        },
        "primary_address_email": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 28
        },
        "primary_address_fax": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 29
        },
        "contact_person_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 29
        },
        "contact_admin": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 30
        },
        "contact_user": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 31
        },
        "owner_contact_person_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 32
        },
        "primary_contact_person_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 33
        },
        "primary_phone_with_code": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 34
        },
        "primary_contact_person_email": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 35
        },
        "primary_contact_fax_with_code": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 35
        },
        "secondary_contact_person_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 36
        },
        "other_contact": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 37
        },
        "kam_remark_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 38
        },
        "account_remark_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 39
        },
        "management_remark_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 40
        },
        "show_remark_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 41
        },
        "primary_address_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 42
        },
        "secondary_address_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 43
        },
        "other_address_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 44
        },
        "default_sale_types": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 45
        },
        "default_sale_terms": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 46
        },
        "permissible_sale_type": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 47
        },
        "permissible_sale_terms": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 48
        },
        "guarntor_commision": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 49
        },
        "broker_commision": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 50
        },
        "premium_charge": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 51
        },
        "wvdDiscount": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 52
        },
        "termDiscount": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 53
        },
        "onlineDiscount": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 54
        },
        "eventDiscount": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 55
        },
        "shipping_company_details_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 56
        },
        "billing_company_details_text": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 57
        },
        "parcel_kam_name": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 4
        },
        "primary_address_city": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 58
        },
        "primary_address_state": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 59
        },
        "primary_country_name": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 60
        },
        "primary_address_zip_code": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 61
        },
        "latest_user_communication_date": {
          "entity_value": true,
          "is_active": true,
          "is_updatable": true,
          "order": 62
        },
        "party_roles_text_super": {
          "entity_value": false,
          "is_active": true,
          "is_updatable": true,
          "order": 1
        },
        "party_roles_text_super1": {
          "entity_value": false,
          "is_active": true,
          "is_updatable": true,
          "order": 1
        }
      }
    }
  ]
  
//let finalConfig = Object.assign(superConfig,partyConfig)

// console.log(JSON.stringify(finalConfig,null,3))

// Object.keys(partyConfig[0]["column_order"]).forEach(partyObject =>{
//   Object.keys(superConfig[0]["column_order"]).forEach(superObject =>{
//     let object;
//     if(partyObject == superObject){
//       object = Object.assign(superConfig[0]["column_order"][superObject],partyConfig[0]["column_order"][partyObject])
//       // object=superConfig[0]["column_order"][superObject];
//       // object["entity_value"] = partyConfig[0]["column_order"][partyObject]["entity_value"]
//       // object["order"] = partyConfig[0]["column_order"][partyObject]["order"]
//       console.log(object)  
//     }               
//   })                    
// })            


// console.log(partyConfig[0]["column_order"]["latest_user_communication_date"])
// console.log(superConfig[0]["column_order"]["latest_user_communication_date"])



let finalConfig={...superConfig[0]["column_order"],...partyConfig[0]["column_order"]}
//console.log(finalConfig)
console.log(finalConfig["party_roles_text_super1"]);
console.log(Object.keys(finalConfig).length);
console.log(Object.keys(partyConfig[0]["column_order"]).length);
console.log(Object.keys(superConfig[0]["column_order"]).length);
  
let finalConfig1 = [
  {
    "tab_name": "party_summary",
    "column_order":finalConfig
  }
]
console.log(JSON.stringify(finalConfig1,null,3))

const final =Object.assign({},superConfig[0]["column_order"],partyConfig[0]["column_order"])
console.log(final)


