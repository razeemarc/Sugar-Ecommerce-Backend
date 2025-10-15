FROM node:20-alpine
WORKDIR /app

# Install security updates and dumb-init
RUN apk update && apk upgrade && apk add --no-cache dumb-init

# Copy package files
COPY package*.json pnpm-lock.yaml ./

# Install pnpm and all dependencies including dev
RUN npm install -g pnpm && pnpm install --frozen-lockfile=false --dev

# Copy all project files
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001
USER nextjs

# Expose port 3000
EXPOSE 3000

# Run Prisma generate (just in case) and start app
CMD ["sh", "-c", "npx prisma generate && dumb-init npm run start"]
