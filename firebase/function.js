
function a(){
    try{
        console.log(aaa)
        return a
    }catch(error){
        console.log("error",error);
        throw error
    }
}


function b(){
    return new Promise((resolve,reject)=>{
        if(1===1){
            resolve("bbbb   resolved")
        }else{
            reject("bbbb  rejected")
        }
    })
}

function x(){
    b().then(async()=>{
        let x= await a()
        console.log("xxx",x);
        
    }).catch(error=>{
        console.log("error=========",error);  
    })
}
x()