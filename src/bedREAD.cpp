#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <stdint.h>
#include <climits>
#include <bitset>


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

std::vector<uint8_t> bedread(
  std::string bedfilename,
  long int N,
  long int VBlock,
  long int id
){
  
  std::ofstream ofs("ll.txt");
  
  
  uint8_t opz;
  char opz2;
  std::bitset<8> xx;
  int scale = countbits()/8;
  uint8_t lable8[4]={192, 48, 12, 3};
  //{0x11000000,0x00110000,0x00001100,0x00000011};// 192 48 12 3
  uint64_t tmpN4 = (uint64_t)N4(N);
  uint64_t PSG = 2 + tmpN4 * (uint64_t)id; // Magic = 3, off = 3-1
  std::vector<uint8_t> re;
  if ( (PSG > LONG_MAX) || (id>VBlock) ) {
    std::cout<<"Overflow";
  }else{
    re.resize(N);
    std::cout<<bedfilename<<std::endl;
    std::cout<<"Len "<<tmpN4<<"\toffset "<<PSG<<"\t Scale: "<<scale<<std::endl;
    std::ifstream uuid(bedfilename.c_str(),std::ios::in | std::ios::binary);
    // seek
    uuid.seekg(PSG,std::ios::cur);
    long int ii=0;
    if (uuid.is_open()){
      for (int i=0;i<tmpN4;i++){
	//uuid.read((char*)&opz,sizeof(uint8_t));
	uuid.get(opz2);
	for (int ij=0;ij<scale;ij++){
	  opz = opz2;
	  opz2>>8;
	  i++;
	}
	if (opz>0) std::cout<<"*";
	xx=opz;
	std::cout<<"log-"<<i<<"\t"<<xx<<"\n";
	if ( ii < N){
	  for (int j=0;j<3;j++) re[ii++] = (opz&lable8[j]);
	}else{
	  break;
	}
      }
    }else{
      std::cout<<"File no exist\n";
    }
for(int o=0;o<N;o++) ofs<re[o]<<",";
    uuid.close();
  }
  return re;
}

/*
int main(int argc, char **argv) {
    std::string file1("/home/yifan/Downloads/ALL.SNP.EUR.chr2.phase3_v5.20130502.genotypes.bed");
    std::vector<uint8_t> result1 = bedread(file1,100,10,0);
    std::cout<<"--re--\n"<<unsigned(result1[0])<<" "<<unsigned(result1[1])<<std::endl;
    return 0;
}
*/
