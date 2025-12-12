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
export async function saveRecord(url, idOrMethod, dataOrData, successMessageOrNull = 'Operación exitosa') {
    try {
        let method, data, successMessage;
        
        if (typeof idOrMethod === 'string' && ['POST', 'PUT', 'DELETE', 'PATCH'].includes(idOrMethod.toUpperCase())) {
            method = idOrMethod;
            data = dataOrData;
            successMessage = successMessageOrNull;
        } else {
            const id = idOrMethod;
            data = dataOrData;
            successMessage = successMessageOrNull;
            method = id ? 'PUT' : 'POST';
            url = id ? `${url}/${id}` : url;
        }

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
        
        if (!response.ok) {
            const errorText = await response.text();
            let errorMessage;
            try {
                const errorJson = JSON.parse(errorText);
                errorMessage = errorJson.error || errorJson.message;
            } catch {
                errorMessage = errorText || `Error ${response.status}`;
            }
            throw new Error(errorMessage);
        }

        const contentType = response.headers.get('content-type');
        let result = null;
        if (contentType && contentType.includes('application/json')) {
            const text = await response.text();
            result = text ? JSON.parse(text) : null;
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
