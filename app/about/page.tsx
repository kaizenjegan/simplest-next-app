export default function ImagePage() {
  return (
    <main>
      <h1>Image from Azure Blob Storage</h1>

      <img
        src="/api/blob"
        alt="Azure Blob"
        style={{ maxWidth: "600px" }}
      />
    </main>
  );
}