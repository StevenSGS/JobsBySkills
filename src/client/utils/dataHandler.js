/**
 * Global Data Handler for CRUD operations.
 * Standardizes API calls, error handling, and user feedback.
 * 
 * @param {string} url - The API endpoint (e.g., '/api/jobs').
 * @param {string} method - HTTP method (POST, PUT, DELETE).
 * @param {object} data - The payload to send (null for DELETE).
 * @param {string} successMessage - Message to show on success.
 * @returns {Promise<object|null>} - Returns response data on success, null on error.
 */
export async function saveRecord(url, method, data, successMessage = 'Operación exitosa') {
    try {
        const options = {
            method: method,
            headers: {
                'Content-Type': 'application/json'
            }
        };

        if (data && method !== 'GET' && method !== 'HEAD') {
            options.body = JSON.stringify(data);
        }

        const response = await fetch(url, options);
        const result = await response.json();

        if (!response.ok) {
            throw new Error(result.error || `Error ${response.status}: ${response.statusText}`);
        }

        if (successMessage) {
            alert(successMessage);
        }

        return result;

    } catch (error) {
        console.error('DataHandler Error:', error);
        alert(`Error: ${error.message}`);
        return null;
    }
}

/**
 * Helper specifically for fetching data (GET wrapper)
 * @param {string} url 
 */
export async function loadRecord(url) {
    try {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`Error loading data: ${response.statusText}`);
        }
        return await response.json();
    } catch (error) {
        console.error('DataHandler Load Error:', error);
        return null;
    }
}
