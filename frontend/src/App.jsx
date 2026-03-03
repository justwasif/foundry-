import {abi} from "./a.js"
import { ethers } from "ethers";
import { useState,useRef } from "react";
function App(){
 
  const [ethAmount,setEthAmount]=useState("")
  
  const connect =async()=> {
    if(typeof window.ethereum!=="undefined"){
      try{
        await ethereum.request({method:"eth_requestAccounts"});
      }catch(error){
        console.log(error);
      };
      const account =await ethereum.request({method:"eth_accounts"});
      console.log(account);
    
    }

  }
  const getBalance=async()=>{
    if(typeof window.ethereum!=="undefined"){
      const provider=new ethers.BrowserProvider(window.ethereum);
      try{
        const balance= await provider.getBalance("0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496")
        console.log(balance)

      }catch(error){
        console.log(error)
      }
    }else{
      alert("install wallet")
    }
  }
  const fund=async()=>{
    if(typeof window.ethereum!=="undefined"){
      const provider =new ethers.BrowserProvider(window.ethereum);
      const signer=await provider.getSigner();
      const contract=new ethers.Contract("0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496",abi,signer)
      try{
        const transactionResponse=await contract.fund({
          value:ethers.parseEther(ethAmount),
        });
        await listenForTransactionMine(transactionResponse,provider);

      }catch(error){
        console.log(error)
      }
    }else{
      alert("hohohhhhhh")
    }

  }


 

  return (
    <>
    <button onClick={connect}>
      connect wallet 
    </button>
    <button onClick={getBalance}> get balance </button>
    <input type="text" value={ethAmount} onChange={(e)=>setEthAmount(e.target.value)}/>
    <button onClick={fund}>fund</button>
    

    </>
  )
}

export default App
