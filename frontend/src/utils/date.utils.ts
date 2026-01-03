/**
 * Formats a Date object to YYYY-MM-DD string using local timezone
 * This avoids timezone conversion issues that occur with toISOString()
 * 
 * @param date - The date to format
 * @returns Date string in YYYY-MM-DD format
 */
export function formatLocalDate(date: Date): string {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

/**
 * Gets today's date in YYYY-MM-DD format using local timezone
 * 
 * @returns Today's date string in YYYY-MM-DD format
 */
export function getTodayLocal(): string {
    return formatLocalDate(new Date());
}
