#pragma once


static void walker_ProbSampleReplace(drand48_data &buf, vector<double>p, vector<int> &a, int nans, vector<int>&ans){
	
	int n = p.size();
	
    double *q, rU;
    int i, j, k;
    int *HL, *H, *L;

    /* Create the alias tables.
       The idea is that for HL[0] ... L-1 label the entries with q < 1
       and L ... H[n-1] label those >= 1.
       By rounding error we could have q[i] < 1. or > 1. for all entries.
     */

	/* Slow enough anyway not to risk overflow */
	HL =(int *) calloc(n, sizeof(int));
	q = (double *)calloc(n, sizeof(double));

    H = HL - 1; L = HL + n;
    for (i = 0; i < n; i++) {
	q[i] = p[i] * n;
	if (q[i] < 1.) *++H = i; else *--L = i;
    }
    if (H >= HL && L < HL + n) { /* So some q[i] are >= 1 and some < 1 */
	for (k = 0; k < n - 1; k++) {
	    i = HL[k];
	    j = *L;
	    a[i] = j;
	    q[j] += q[i] - 1;
	    if (q[j] < 1.) L++;
	    if(L >= HL + n) break; /* now all are >= 1 */
	}
    }
    for (i = 0; i < n; i++) q[i] += i;

    /* generate sample */
    for (i = 0; i < nans; i++) {
    	double dr;
    	drand48_r(&buf, &dr);
	rU = dr * n;
	k = (int) rU;
	ans[i] = (rU < q[k]) ? k+1 : a[k]+1;
    }

	free(HL);
	free(q);
}