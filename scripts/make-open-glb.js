#!/usr/bin/env node

const fs = require('fs');

const [inputPath, outputPath] = process.argv.slice(2);
if (!inputPath || !outputPath) {
  console.error('usage: make-open-glb.js CLOSED.glb OPEN.glb');
  process.exit(2);
}

const input = fs.readFileSync(inputPath);
if (input.readUInt32LE(0) !== 0x46546c67) throw new Error('not a GLB file');

const jsonLength = input.readUInt32LE(12);
const jsonType = input.readUInt32LE(16);
if (jsonType !== 0x4e4f534a) throw new Error('GLB has no JSON chunk');
const document = JSON.parse(input.subarray(20, 20 + jsonLength).toString());
const hinge = (document.nodes || []).find((node) => node.name === 'desk top right hinge');
if (!hinge) throw new Error('desk top right hinge node not found');

const angle = -88 * Math.PI / 180;
hinge.rotation = [Math.sin(angle / 2), 0, 0, Math.cos(angle / 2)];

const json = Buffer.from(JSON.stringify(document));
const paddedJsonLength = (json.length + 3) & ~3;
const jsonChunk = Buffer.alloc(paddedJsonLength, 0x20);
json.copy(jsonChunk);
const binary = input.subarray(20 + jsonLength);
const output = Buffer.alloc(12 + 8 + jsonChunk.length + binary.length);
output.writeUInt32LE(0x46546c67, 0);
output.writeUInt32LE(2, 4);
output.writeUInt32LE(output.length, 8);
output.writeUInt32LE(jsonChunk.length, 12);
output.writeUInt32LE(0x4e4f534a, 16);
jsonChunk.copy(output, 20);
binary.copy(output, 20 + jsonChunk.length);
fs.writeFileSync(outputPath, output);
