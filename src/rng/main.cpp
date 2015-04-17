#include <vector>
#include <iostream>

#include "rnd1.h"

using namespace std;

//walker_ProbSampleReplace(int n, double *p, int *a, int nans, int *ans)


template<typename T>
ostream& operator<< (ostream& out, const vector<T>& v) {
    //out << "[";
    size_t last = v.size() - 1;
    for(size_t i = 0; i < v.size(); ++i) {
        out << v[i];
        if (i != last) 
            out << ", ";
    }
    //out << "]";
    return out;
}

vector<int> sample_replace(vector<double>prob, int sample_size, int seed = 0){
	
	drand48_data buf;
	srand48_r(seed, &buf);
  vector<int> re;
  re.resize(sample_size);
  int n = prob.size();
  
  vector<int> a(n, -1);// This is a tmp table
  walker_ProbSampleReplace(buf, prob, a, sample_size, re);
  return(re);
}

int main(int argc, char **argv) {
    double prob[]={.1,.2,.5,.2};
    vector<double> p(prob,prob+sizeof(prob)/sizeof(double));
    vector<int> re;
    re=sample_replace(p,500);
    
    cout<<re<<endl;
    
    return 0;
}
