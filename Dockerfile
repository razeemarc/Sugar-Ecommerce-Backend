FROM node:20-alpine
WORKDIR /app

# Install security updates and pnpm
RUN apk update && apk upgrade && apk add --no-cache dumb-init

# Copy package.json and lock file
COPY package*.json pnpm-lock.yaml ./

# Install dependencies using pnpm
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Create non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
USER nextjs

EXPOSE 3000
CMD ["dumb-init", "npm", "run", "start"]
