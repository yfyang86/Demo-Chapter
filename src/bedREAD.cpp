/*
 Hints:
 
 1.
 
 offset
 
 The type std::streamoff is a signed integral type of sufficient size to represent 
 the maximum possible file size supported by the operating system. 
 Typically, this is a typedef to (singned) long long.
 
 Hence it has no problem
 
 2.
 
 There is no guanrantee that `unsigned char` is 8 bits. Hence I use a trick to check that:
 
 int countbits(){
    char c;
    int bits=0;
    for ( c = 1; c; c <<= 1, bits++ );
    return bits;
}

will counts the bits, then

use bits operation within each 

while ( ifsream.get(char x)  && endcondition){

for (i in 1:(bits/8)){
  do sth
  bit = x>>8;
  }
 }
 
 */

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdint.h>
#include <climits>
//bitset: used to print
//#include <bitset>


inline long N4(long n){
  if(n%4 == 0){
    return(n/4);
  }else{
    return (n/4 + 1);
  }
  
}

int countbits(){
    char c;
    int bits=0;
    for ( c = 1; c; c <<= 1, bits++ );
    return bits;
}


//usage: bedread(string befile, long int smaple_size, long int VBlock, long int id)

std::vector<uint8_t> bedread(
  std::string bedfilename,
  long int N,
  long int VBlock,
  long int id
){
  uint8_t opz;
  char opz2;
  //std::bitset<8> xx;
  int scale = countbits()/8;
  uint8_t lable8[4]={0xC0,0x30,0xC,0x3};// 192 48 12 3
  uint64_t tmpN4 = (uint64_t)N4(N);
  uint64_t PSG = 2 + tmpN4 * (uint64_t)id; // Magic = 3, off = 3-1
  std::vector<uint8_t> re;
  if ( (PSG > LONG_MAX) || (id>VBlock) ) {
    std::cout<<"Overflow";
  }else{
    re.resize(N);
    /* debug: file information
    std::cout<<bedfilename<<std::endl;
    std::cout<<"Len "<<tmpN4<<"\toffset "<<PSG<<"\t Scale: "<<scale<<std::endl;
    */
    std::ifstream uuid(bedfilename.c_str(),std::ios::in | std::ios::binary);
    // seek PSG offset
    uuid.seekg(PSG,std::ios::cur);
    long int ii=0;
    if (uuid.is_open()){
      int i=0;
      while(i<tmpN4 && uuid.get(opz2)){
	for (int ij=0;ij<scale;ij++){
	  opz = opz2; 		// lower 8 bits
	  opz2 = opz2>>8; 	// move to right by 8
	  //xx=opz; 		// for print
	  //std::cout<<"log-"<<i<<"\t"<<xx<<"\n";
	  for (int j=0;j<=3;j++) {
	    re[ii++] = (opz & lable8[j]);
	    re[ii-1] = re[ii-1] >> 2*(3-j);
	    if ( ii >= N){
	      goto outforloop;// I need two breaks...
	    }
	  }
	
	  i++;
	}
      }
    }else{
      std::cout<<"File no exist\n";
    }
outforloop: uuid.close();
  }
  return re;
}


// id start with 0

int main(int argc, char **argv) {
    std::string file1("/home/yifan/Downloads/ALL.SNP.EUR.chr2.phase3_v5.20130502.genotypes.bed");
    std::vector<uint8_t> result1 = bedread(file1,17,10,0);
    std::cout<<"--re--\n";
    for (int i=0;i<10;i++ ) std::cout<<"Sample "<<i<<" val:"<<+result1[i]<<std::endl;
    return 0;
}
