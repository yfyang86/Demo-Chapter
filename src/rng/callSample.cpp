#include <R.h>

#include <vector>
using std::vector;
#include <iostream>
using std::ostream;

#include "rnd1.h"

template<typename T>
ostream& operator<< (ostream& out, const vector<T>& v) {
    out << "Val\n";
    size_t last = v.size() - 1;
    for(size_t i = 0; i < v.size(); ++i) {
        out << v[i];
        if (i != last) 
            out << "\n";
    }
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

extern "C"{
void ReplacedSample(double * prob, int *n,int *N,int *seed) {
    std::vector<double> p(prob,prob+n[0]);
    std::vector<int> re;
    re=sample_replace(p,N[0]);
    std::cout<<re<<std::endl;
}
}

