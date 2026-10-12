# ========== 阶段一：构建阶段（用完即弃） ==========
# 拉取一个自带 Node 20 环境的基础镜像，alpine 是精简版 Linux（约 50MB）
FROM node:20-alpine AS builder

# 容器内的工作目录，后面所有命令都在这个目录下执行
WORKDIR /app

# 先只拷贝 package*.json —— 利用 Docker 的层缓存：
# 只要依赖没变，下次构建会直接复用缓存，不用重新 npm ci
COPY package*.json ./

# 按锁文件精确安装依赖（CI 环境推荐 ci 而不是 install）
RUN npm ci

# 再拷贝源代码
COPY . .

# 执行构建，产出 dist 目录
RUN npm run build

# ========== 阶段二：运行阶段（最终镜像只有这一层） ==========
# Nginx 精简版镜像，只用来托管静态文件
FROM nginx:alpine

# 把上一个阶段构建出的 dist，拷贝到 Nginx 的默认站点目录
# 注意：node_modules、Node 环境全都不会进入最终镜像
COPY --from=builder /app/dist /usr/share/nginx/html

# 用我们自己的 Nginx 配置覆盖默认配置（处理 SPA 路由刷新 404 问题）
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 声明容器对外暴露 80 端口（仅声明作用，方便阅读）
EXPOSE 80

# 容器启动时前台运行 Nginx
CMD ["nginx", "-g", "daemon off;"]
