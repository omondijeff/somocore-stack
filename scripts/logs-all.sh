#!/bin/bash

# SomoCore Stack - View All Logs
# This script shows logs from all running services

echo "📋 SomoCore Stack - Service Logs"
echo "================================="

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -f, --follow     Follow log output (like tail -f)"
    echo "  -n, --lines NUM  Number of lines to show (default: 100)"
    echo "  --backend        Show only backend logs"
    echo "  --dashboard      Show only dashboard logs"
    echo "  --db             Show only database logs"
    echo "  -h, --help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                    # Show last 100 lines from all services"
    echo "  $0 -f                 # Follow all logs"
    echo "  $0 --backend -f       # Follow only backend logs"
    echo "  $0 -n 50              # Show last 50 lines"
}

# Default values
FOLLOW=""
LINES="100"
SERVICE=""

# Parse command line arguments
while (( "$#" )); do
    case "$1" in
        -f|--follow)
            FOLLOW="-f"
            shift
            ;;
        -n|--lines)
            if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
                LINES="$2"
                shift 2
            else
                echo "❌ Error: Argument for $1 is missing" >&2
                exit 1
            fi
            ;;
        --backend)
            SERVICE="backend"
            shift
            ;;
        --dashboard)
            SERVICE="dashboard"
            shift
            ;;
        --db)
            SERVICE="db"
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "❌ Error: Unsupported flag $1" >&2
            show_usage
            exit 1
            ;;
    esac
done

# Check if backend services are running
if [ ! -f "backend/docker-compose.dev.yml" ]; then
    echo "❌ Backend docker-compose.dev.yml not found"
    exit 1
fi

cd backend

case "$SERVICE" in
    "backend")
        echo "🔧 Backend API Logs:"
        docker-compose -f docker-compose.dev.yml logs $FOLLOW --tail=$LINES app
        ;;
    "dashboard")
        echo "🎛️ Dashboard logs not available via Docker (runs locally)"
        echo "   Dashboard runs as local npm process"
        ;;
    "db")
        echo "🗄️ Database Logs:"
        docker-compose -f docker-compose.dev.yml logs $FOLLOW --tail=$LINES mongo
        ;;
    *)
        echo "📋 All Service Logs (last $LINES lines):"
        echo ""
        if [ "$FOLLOW" == "-f" ]; then
            echo "Following logs... (Press Ctrl+C to stop)"
            docker-compose -f docker-compose.dev.yml logs -f
        else
            docker-compose -f docker-compose.dev.yml logs --tail=$LINES
        fi
        ;;
esac

cd .. 