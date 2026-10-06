import { NextResponse } from "next/server";
import { BlobServiceClient } from "@azure/storage-blob";
import { DefaultAzureCredential } from "@azure/identity";

export async function GET() {
  try {
    const accountName = process.env.AZURE_STORAGE_ACCOUNT_NAME!;

    const credential = new DefaultAzureCredential();

    const blobServiceClient = new BlobServiceClient(
      `https://${accountName}.blob.core.windows.net`,
      credential
    );

    const containerClient =
      blobServiceClient.getContainerClient("rocketsite");

    const blobClient =
      containerClient.getBlobClient("zig1.PNG");

    const response = await blobClient.download();

    if (!response.readableStreamBody) {
      return new Response("Image not found", { status: 404 });
    }

    const chunks: Buffer[] = [];

    for await (const chunk of response.readableStreamBody) {
      chunks.push(Buffer.from(chunk));
    }

    const imageBuffer = Buffer.concat(chunks);

    return new Response(imageBuffer, {
      headers: {
        "Content-Type": response.contentType ?? "image/png",
      },
    });

  } catch (error) {
    console.error(error);

    return NextResponse.json(
      { error: "Failed to read blob" },
      { status: 500 }
    );
  }
}