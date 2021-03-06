/**
 * Header for interfacing with edgebox (or box proposals in general). Calculates
 * Saliency score for each bounding box.
 *
 * @author Mohamed El Banani
 * @date Nov 15, 2016
 */

 #include <opencv2/core/core.hpp>
 #include <opencv2/highgui/highgui.hpp>
 #include <opencv2/imgproc/imgproc.hpp>
 #include <cmath>
 #include <typeinfo>
 #include <iostream>
 #include <sstream>
 #include <fstream>
 #include <string>
 #include <cstdio>

const int NUM_PROPOSALS = 10000;
/**
 * A structure for object proposals.
 * 	bbox            rectangle object that covers the object proposal.
 * 	confScore       The confidence score output by the proposal Generator
 * 	saliencyScore   The saliency score associated with the object
 * 	label           the object label associated with the proposal
 */
 struct proposal
 {
 	cv::Rect bbox;
 	int confScore;
    int saliencyScore;
    int label;
};


int calculateSaliencyScore(cv::Mat&, proposal);
int calculateSaliencyScoreProto(cv::Mat&);
void drawBB(cv::Mat&, proposal, cv::Scalar);
void drawBB(cv::Mat&, cv::Rect, cv::Scalar);
// void drawBB(cv::Mat&, cv::Rect, const std::string&, cv::Scalar);
proposal* arrayToProposals(int[][5], int, int);
double  calculateIOU(cv::Rect, cv::Rect);
void csvToProposalList(const char*, int[NUM_PROPOSALS][5]);
