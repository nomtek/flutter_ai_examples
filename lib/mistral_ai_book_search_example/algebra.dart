import 'dart:math';

// use it find the most similar text in the book based on embeddings
// of the question and the book fragment
double calculateCosineSimilarity(List<double> vectorA, List<double> vectorB) {
  final dotProduct = calculateDotProduct(vectorA, vectorB);
  final magnitudeA = calculateMagnitude(vectorA);
  final magnitudeB = calculateMagnitude(vectorB);
  return dotProduct / (magnitudeA * magnitudeB);
}

double calculateDotProduct(List<double> vectorA, List<double> vectorB) {
  assert(vectorA.length == vectorB.length, 'Vectors must be of same length');
  var dotProduct = 0.0;
  for (var i = 0; i < vectorA.length; i++) {
    dotProduct += vectorA[i] * vectorB[i];
  }
  return dotProduct;
}

double calculateMagnitude(List<double> vector) => sqrt(
      vector.fold(
        0,
        (previousValue, element) => previousValue + element * element,
      ),
    );
