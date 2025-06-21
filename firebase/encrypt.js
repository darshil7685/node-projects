import CryptoJS from 'crypto-js'

let secretKey='secretKey'

async function encryptData(data,encrypted_keys){
        try{ 
            if (Array.isArray(data)) {
                return Promise.all(data.map(async obj => {return await encryptData(obj,encrypted_keys)}))
                // return data.map(obj => encryptData(obj,encrypted_keys))
            } else if(typeof data === 'object' && data !== null) {
                
                for (let key in data) {
                    
                    if (data[key] !== null && data[key] !== undefined && data[key] !== '' && data[key] !== '-' && typeof data[key] == 'string') {
                       
                        if (encrypted_keys.includes(key)) {
                            data[key] = CryptoJS.AES.encrypt(data[key], secretKey).toString();  
                            
                        } 
                    }else{
                        data[key] = await encryptData(data[key],encrypted_keys)
                    }
                }
            }
            return data
        }catch(error){
            console.log("encryptDataerror",error);
            throw error
        }
}
async function decryptData(data,decrypted_keys){
   
    try{
        if (Array.isArray(data)) {
            return Promise.all(data.map(async obj => {return await decryptData(obj,decrypted_keys)}))
            // return data.map(obj => decryptData(obj,decrypted_keys))
        } else if (typeof data === 'object' && data !== null) {
            for (let key in data) {
                
                if (data[key] !== null && data[key] !== undefined && data[key] !== '' && data[key] !== '-' && typeof data[key] == 'string' ) {
                    
                    if (decrypted_keys.includes(key)) {
                        data[key] = CryptoJS.AES.decrypt(data[key], secretKey).toString(CryptoJS.enc.Utf8); 
                    } 
                }else{
                    data[key]= await decryptData(data[key], decrypted_keys);
                }
            }
        }
        
        return data;
    }catch(error){
        throw error
    }
}


let input=[
    {
      "question_comments":
        {
          "COMMUNICATION_SKILLS":
            [
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00220",
                "candidate_name": "Priyank Khanpara",
                "evaluator_code": "SRK00220",
                "evaluator_name": "Priyank Khanpara",
                "relation_type_name": "Self",
                "question_number": "que7",
                "question_title": "Please explain the reason for your scores in communication skills?",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00220",
                "candidate_name": "Priyank Khanpara",
                "evaluator_code": "SRK00229",
                "evaluator_name": "Ankit K Sharma",
                "relation_type_name": "Lead",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00927",
                "candidate_name": "Neer Timbadiya",
                "evaluator_code": "SRK00229",
                "evaluator_name": "Ankit K Sharma",
                "relation_type_name": "Lead",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00964",
                "candidate_name": "Shakshi Ajit Thakur",
                "evaluator_code": "SRK00229",
                "evaluator_name": "Ankit K Sharma",
                "relation_type_name": "Lead",
                "question_number": "que7",
                "question_title": "Please explain the reason for your scores in communication skills?",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00220",
                "candidate_name": "Priyank Khanpara",
                "evaluator_code": "SRK00964",
                "evaluator_name": "Shakshi Ajit Thakur",
                "relation_type_name": "Peer",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "id":234,
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00964",
                "candidate_name": "Shakshi Ajit Thakur",
                "evaluator_code": "SRK00927",
                "evaluator_name": "Neer Timbadiya",
                "relation_type_name": "Peer",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "Good",
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00964",
                "candidate_name": "Shakshi Ajit Thakur",
                "evaluator_code": "SRK00927",
                "evaluator_name": "Neer Timbadiya",
                "relation_type_name": "Peer",
                "question_number": "que7",
                "question_title": "Please explain the reason for your scores in communication skills?",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "Bad",
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00220",
                "candidate_name": "Priyank Khanpara",
                "evaluator_code": "SRK00964",
                "evaluator_name": "Shakshi Ajit Thakur",
                "relation_type_name": "Peer",
                "question_number": "que7",
                "question_title": "Please explain the reason for your scores in communication skills?",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00964",
                "candidate_name": "Shakshi Ajit Thakur",
                "evaluator_code": "SRK00964",
                "evaluator_name": "Shakshi Ajit Thakur",
                "relation_type_name": "Self",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00220",
                "candidate_name": "Priyank Khanpara",
                "evaluator_code": "SRK00220",
                "evaluator_name": "Priyank Khanpara",
                "relation_type_name": "Self",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00964",
                "candidate_name": "Shakshi Ajit Thakur",
                "evaluator_code": "SRK00229",
                "evaluator_name": "Ankit K Sharma",
                "relation_type_name": "Lead",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00927",
                "candidate_name": "Neer Timbadiya",
                "evaluator_code": "SRK00927",
                "evaluator_name": "Neer Timbadiya",
                "relation_type_name": "Self",
                "question_number": "que7",
                "question_title": "Please explain the reason for your scores in communication skills?",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00927",
                "candidate_name": "Neer Timbadiya",
                "evaluator_code": "SRK00964",
                "evaluator_name": "Shakshi Ajit Thakur",
                "relation_type_name": "Peer",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              },
              {
                "survey_id": 69,
                "survey_title": "Security",
                "survey_start": "2025-01-27T12:19:00",
                "survey_end": "2025-01-31T12:19:00",
                "candidate_code": "SRK00220",
                "candidate_name": "Priyank Khanpara",
                "evaluator_code": "SRK00927",
                "evaluator_name": "Neer Timbadiya",
                "relation_type_name": "Peer",
                "question_number": "que6",
                "question_title": "Provides honest feedback that facilitates improvement & growth of surroundings.",
                "question_category_key": "COMMUNICATION_SKILLS",
                "review": "-"
              }
            ],
        },
    },
  ]
  
function x(){
    return new Promise((resolve,reject)=>{return resolve("resolved")})
}

async function a(){
    x().then(async ()=>{
      
    let result=await encryptData(input,['review'])
    console.log("result",JSON.stringify(result))
    
    result= await decryptData(result,['review'])
    console.log("==============================================================================")
    console.log("re",JSON.stringify(result));
      
    }).catch((error)=>{
        console.log("error",error);
    })
}
a()

