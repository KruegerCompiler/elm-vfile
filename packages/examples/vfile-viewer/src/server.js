import Fastify from "fastify";
import toVFile from "to-vfile";
import { resolve as resolvePath } from "path";
import fastifyStatic from "fastify-static";

const fastify = Fastify({ logger: true });

fastify.register(fastifyStatic, {
  root: resolvePath(__dirname, "../wwwroot"),
  prefix: "/"
});

fastify.get("/data/:filename", async (request, reply) => {
  const path = resolvePath(__dirname, "../data", request.params.filename);
  const file = await toVFile(path);
  return { path: path, file: file };
});

fastify.get("/data/:filename/contents", async (request, reply) => {
  const path = resolvePath(__dirname, "../data", request.params.filename);
  const file = await toVFile.read(path);
  return { path: path, file: file };
});

const start = async () => {
  try {
    await fastify.listen(3000);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};
start();
