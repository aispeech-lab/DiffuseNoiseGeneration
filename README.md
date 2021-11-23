# Generating Nonstationary Multisensor Signals under a Spatial Coherence Constraint

This code is slightly modified based on the work [1], if you find this code is useful, plese cite the original work [1]

Noise fields encountered in real-life scenarios can often be approximated as spherical or cylindrical noise fields. The characteristics of the noise field can be described by a spatial coherence function. For simulation purposes, researchers in the signal processing community often require sensor signals that exhibit a specific spatial coherence function. In addition, they often require a specific type of noise such as temporally correlated noise, babble speech that comprises a mixture of mutually independent speech fragments, or factory noise. Existing algorithms are unable to generate sensor signals such as babble speech and factory noise observed in an arbitrary noise field. 

In [1] an efficient algorithm is proposed that generates multisensor signals under a predefined spatial coherence constraint. The benefit of the developed algorithm is twofold. Firstly, there are no restrictions on the spatial coherence function. Secondly, to generate M sensor signals the algorithm requires only M mutually independent noise signals. The performance evaluation shows that the developed algorithm is able to generate a more accurate spatial coherence between the generated sensor signals compared to the so-called image method that is frequently used in the acoustic signal processing community.

[1]. E.A.P. Habets, I. Cohen and S. Gannot  
Generating nonstationary multisensor signals under a spatial coherence constraint, Journal of the Acoustical Society of America, Vol. 124, Issue 5, pp. 2911-2917, Nov. 2008.
