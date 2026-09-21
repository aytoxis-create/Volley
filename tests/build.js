const assert = require("node:assert/strict")
const fs = require("node:fs")
const os = require("node:os")
const path = require("node:path")
const { spawnSync } = require("node:child_process")
const root = path.resolve(__dirname, "..")
const temporary = fs.mkdtempSync(path.join(os.tmpdir(), "volley-build-test-"))
try {
	for (const file of ["build.js", "combine.js"]) fs.copyFileSync(path.join(root, file), path.join(temporary, file))
	fs.cpSync(path.join(root, "src"), path.join(temporary, "src"), { recursive: true })
	const output = path.join(temporary, "volley.lua")
	const run = mode => spawnSync(process.execPath, [path.join(temporary, "build.js"), mode], {
		encoding: "utf8", env: { ...process.env, NODE_PATH: [path.join(root, "node_modules"), process.env.NODE_PATH].filter(Boolean).join(path.delimiter) }
	})
	for (const mode of ["build", "minify"]) {
		let previous
		for (let i = 0; i < 3; i++) {
			const result = run(mode)
			assert.equal(result.status, 0, result.stderr)
			const content = fs.readFileSync(output)
			assert.ok(content.length > 1000)
			if (previous) assert.deepEqual(content, previous)
			previous = content
		}
	}
	const good = fs.readFileSync(output)
	const source = path.join(temporary, "src", "init.lua")
	fs.appendFileSync(source, "\nlocal = broken syntax")
	assert.notEqual(run("minify").status, 0)
	assert.deepEqual(fs.readFileSync(output), good)
	fs.unlinkSync(source)
	assert.notEqual(run("build").status, 0)
	assert.deepEqual(fs.readFileSync(output), good)
	const combine = require(path.join(root, "combine"))
	assert.throws(() => combine([], output))
	assert.deepEqual(fs.readFileSync(output), good)
	assert.equal(fs.readdirSync(temporary).filter(file => file.endsWith(".tmp")).length, 0)
	console.log("Build tests passed: deterministic output and failure preservation.")
} finally {
	fs.rmSync(temporary, { recursive: true, force: true })
}
