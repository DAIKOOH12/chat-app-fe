# Base stage for dependencies
FROM node:18-alpine AS base
WORKDIR /app
ENV NODE_ENV=production
ENV PATH /app/node_modules/.bin:$PATH

# Dependencies stage - only rebuilds if package.json changes
FROM base AS dependencies
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
# Install dependencies using the appropriate package manager
RUN \
  if [ -f yarn.lock ]; then yarn install --frozen-lockfile --production=false; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else npm i; \
  fi

# Builder stage - builds the application
FROM dependencies AS builder
WORKDIR /app
COPY . .
# Set memory limit for Node during build
ENV NODE_OPTIONS="--max-old-space-size=1536"
RUN \
  if [ -f yarn.lock ]; then yarn build; \
  elif [ -f package-lock.json ]; then npm run build; \
  elif [ -f pnpm-lock.yaml ]; then pnpm build; \
  else npm run build; \
  fi

# Production stage - only contains necessary runtime files
FROM base AS runner
WORKDIR /app

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nodejs

# Copy built application from builder stage
COPY --from=builder --chown=nodejs:nodejs /app/build ./build
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/public ./public
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./package.json

# Set environment variables
ENV PORT=3000
ENV HOST=0.0.0.0
ENV NODE_ENV=production

# Switch to non-root user
USER nodejs

# Expose the port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]