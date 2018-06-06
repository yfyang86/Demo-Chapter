#include <RcppArmadillo.h>
// [[Rcpp::depends("RcppArmadillo")]]

using namespace std;
using namespace arma;


double calauc(vec & labels, vec & scores,int n,int posclass);
void my_print(const vec & X);
ivec chase_vec_mcmc(mat pred,vec objs,int nt,int n,int npos,int maxit,double rate,int st,int dt);
vec find_vec(ivec act,int n,int maxit,double obj,double rate);

double trapezoidArea(double X1, double X2, double Y1, double Y2) {
  double base   = std::abs(X1-X2);
  double height =     (Y1+Y2)/2.0;
	return (base * height);
}


// [[Rcpp::export]]
double calauc(ivec & labels, vec & scores,int n,int posclass) {
  typedef std::pair<float,int> mypair;
  std::vector<mypair> L(n);
  for(int i = 0; i < n; i++) {
		L[i].first  = scores(i);
		L[i].second = labels(i);
	}
	std::sort   (L.begin(),L.end());
	std::reverse(L.begin(),L.end());


	int N=0,P=0;
	for(int i = 0; i < n ; i++) {
		if(labels[i] == posclass) P++;
		else N++;
	}

	double              A       = 0;
	double              fprev   = INT_MIN; //-infinity
	unsigned long long	FP      = 0, 
                        TP      = 0,
                        FPprev  = 0, 
                        TPprev  = 0;
    
	for(int i = 0 ; i < n; i++) {
		double fi   = L[i].first;
		double label= L[i].second;		
		if(fi != fprev) {
			A       = A + (trapezoidArea(FP*1.0/N,FPprev*1.0/N,TP*1.0/P,TPprev*1.0/P));
			fprev	= fi;
			FPprev	= FP;
			TPprev	= TP;
		}
		if(label  == posclass)
			TP = TP + 1;
		else
			FP = FP + 1;
	}
	A = A + trapezoidArea(1.0,FPprev*1.0/N,1.0,TPprev*1.0/P); 
	return A;
}

void my_print(const vec & X){
  for(uword i=0; i < X.n_elem ;i++) { cout << X(i) << ' '; }
}

// [[Rcpp::export]]
vec find_vec(ivec act,int n,int maxit,double obj,double rate){   
    
    vec pred(n);
    //pred.fill(1);
    for(int i=0;i<n;i++){
      pred(i)= (double)i/n;
    }  
    double delta_old=1,delta_new=0;
    double auc=0;
    double best_auc=0;
      for(int i=0;i<maxit;i++){
      int pos_1=rand() % n;
      int pos_0=rand() % n;
      double temp=pred(pos_1);
      pred(pos_1)=pred(pos_0);
      pred(pos_0)=temp;
      delta_new=0;

        auc=calauc(act,pred,n,1);
        delta_new=abs(obj-auc);
      if(exp((delta_old-delta_new)/rate) > ((double)rand() / (RAND_MAX))){
        delta_old=delta_new;
        best_auc=auc;
        }
      else{
        double temp=pred(pos_1);
        pred(pos_1)=pred(pos_0);
        pred(pos_0)=temp;
      }
      cout<<i<<" :"<<best_auc<<endl;
    }
    return pred;
}

// [[Rcpp::export]]
ivec chase_vec_mcmc(mat pred,vec objs,int nt,int n,int npos,int maxit,double rate,int st,int dt){   
    int ncol=pred.n_cols;
    ivec act(n);
    act.fill(1);
    ivec guess(n);
    ivec guess_old(n);
    guess_old.fill(0);
    guess.fill(0);
    vec best_auc(ncol);
    best_auc.fill(0);
    ivec index(n);
    for(int i=0;i<n;i++){
      index(i)=i;  
    }
    index=shuffle(index);
    for(int i=0;i<npos;i++){
      act(index(i))=0;
    }  
    double delta_old=10,delta_new=0;
    vec auc(ncol);
    auc.fill(0);
    
    for(int i=0;i<maxit;i++){

      uvec pos_set=find(act);
      uvec neg_set=find(act==0);
      int pos_1=rand() % pos_set.n_elem;
      int pos_0=rand() % neg_set.n_elem;
      act(pos_set(pos_1))=0;
      act(neg_set(pos_0))=1;
      delta_new=0;
      
      for(int j=0;j<nt;j++){
        vec pred_j=pred.col(j);
        auc(j)=calauc(act,pred_j,n,1);
        delta_new+=abs(objs(j)-auc(j));
      }
      if(exp((delta_old-delta_new)/rate) > ((double)rand() / (RAND_MAX))){

        delta_old=delta_new;
        best_auc.head(nt)=auc.head(nt);
        }
      else{
        act(pos_set(pos_1))=1;
        act(neg_set(pos_0))=0;
      }
            if(i % 100==0){
              for(int j=nt;j<ncol;j++){
                vec pred_j=pred.col(j);
                best_auc(j)=calauc(act,pred_j,n,1);
                }
        cout << i<<" : " ;
        my_print(best_auc);
        cout<<" delta: "<<delta_old <<endl;
      }
      if((i >= st) && (i % dt==0)){
        guess+=act;
        cout<<"difference: "<<sum(abs(guess_old-act))<<endl;
        guess_old=act+0;
      }
    }  
    
    return guess;
}
