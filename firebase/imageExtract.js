import vision from "@google-cloud/vision"

// Create a client
const client = new vision.ImageAnnotatorClient();

async function extractTextFromImage() {
  const [result] = await client.textDetection("resumm.png"); // Path to image
  const detections = result.textAnnotations;
  console.log("Extracted Text:", detections[0]?.description || "No text found");
}

extractTextFromImage().catch(console.error);
