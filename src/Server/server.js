import express from "express";
import fs from "fs/promises";
import path from "path";
import crypto from "crypto";

const app = express();
const PORT = process.env.PORT || 3000;
const ROOMS_DIR = path.resolve("rooms");

app.use(express.json({ limit: "1mb" }));

await fs.mkdir(ROOMS_DIR, { recursive: true });

function roomFile(roomName) {
  const safe = String(roomName).trim().toLowerCase().replace(/[^a-z0-9._-]/g, "-");
  return path.join(ROOMS_DIR, `${safe}.json`);
}

function etagOf(buffer) {
  return `"sha1-${crypto.createHash("sha1").update(buffer).digest("hex")}"`;
}

app.get("/rooms", async (_req, res) => {
  try {
    const files = await fs.readdir(ROOMS_DIR);
    const rooms = [];

    for (const f of files.filter(f => f.endsWith(".json"))) {
      const p = path.join(ROOMS_DIR, f);
      const content = await fs.readFile(p, "utf-8").catch(() => null);
      if (!content) continue;

      let data;
      try {
        data = JSON.parse(content);
      } catch {
        continue;
      }

      if (data.status === "on" && data.started === false) {
        rooms.push(f.replace(/\.json$/i, ""));
      }
    }

    res.json(rooms);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to list rooms" });
  }
});

app.get("/rooms/:name", async (req, res) => {
  try {
    const file = roomFile(req.params.name);
    const data = await fs.readFile(file).catch(() => null);

    if (!data) {
      return res.status(404).json({ error: "Room not found" });
    }

    const etag = etagOf(data);
    if (req.headers["if-none-match"] === etag) {
      return res.status(304).end();
    }

    res.setHeader("ETag", etag);
    res.setHeader("Content-Type", "application/json; charset=utf-8");
    res.send(data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to read room" });
  }
});

app.post("/rooms/:name", async (req, res) => {
  try {
    const file = roomFile(req.params.name);
    const tmp = `${file}.tmp`;

    const json = JSON.stringify(req.body, null, 2);
    await fs.writeFile(tmp, json, "utf-8");
    await fs.rename(tmp, file);

    res.status(201).json({ ok: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to save room" });
  }
});

app.delete("/rooms/:name", async (req, res) => {
  try {
    const file = roomFile(req.params.name);
    await fs.unlink(file).catch(() => null);
    res.json({ ok: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to delete room" });
  }
});

app.get("/health", (_req, res) => res.json({ ok: true }));

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
