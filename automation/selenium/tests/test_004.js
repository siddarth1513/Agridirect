describe('Selenium Test 4', () => {
    it('should perform action 4', async () => {
        await browser.url('https://example.com');
        // TODO: add real steps
        expect(await browser.getTitle()).toBe('Example Domain');
    });
});
